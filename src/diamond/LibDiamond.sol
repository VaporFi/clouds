// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/diamond/IDiamondCut.sol";

error Diamond__EmptyContract();
error Diamond__FunctionAlreadyExists();
error Diamond__ImmutableFunction();
error Diamond__InexistentFunction();
error Diamond__InvalidAddressZero();
error Diamond__InvalidFacetAction();
error Diamond__MustBeOwner();
error Diamond__NoSelectorsInFacetCut();
error Diamond__RemoveFacetAddressMustBeZero();
error Diamond__SameFunctionAlreadyExists();

error Diamond__InitializationFailed(
    address initializationContractAddress,
    bytes data
);

/// @title Diamond
/// @author mektigboy
/// @notice
/// @dev
library LibDiamond {
    //////////////
    /// EVENTS ///
    //////////////

    event DiamondCut(
        IDiamondCut.FacetCut[] diamondCut,
        address initializationContractAddress,
        bytes data
    );

    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    ///////////////
    /// STORAGE ///
    ///////////////

    bytes32 constant DIAMOND_STORAGE_POSITION =
        keccak256("diamond.standard.diamond.storage");

    /////////////////
    /// STRUCTURE ///
    /////////////////

    struct FacetAddressAndPosition {
        address facetAddress;
        uint96 functionSelectorPosition;
    }

    struct FacetFunctionSelectors {
        bytes4[] functionSelectors;
        uint256 facetAddressPosition; // Position of 'facetAddress' in 'facetAddresses' array
    }

    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
        mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
        address[] facetAddresses;
        mapping(bytes4 => bool) supportedInterfaces;
        address contractOwner;
    }

    /////////////
    /// LOGIC ///
    /////////////

    function diamondStorage()
        internal
        pure
        returns (DiamondStorage storage ds)
    {
        bytes32 position = DIAMOND_STORAGE_POSITION;

        assembly {
            ds.slot := position
        }
    }

    /////////////////
    /// OWNERSHIP ///
    /////////////////

    function setContractOwner(address _newOwner) internal {
        DiamondStorage storage ds = diamondStorage();

        address oldOwner = ds.contractOwner;

        ds.contractOwner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function contractOwner() internal view returns (address co) {
        co = diamondStorage().contractOwner;
    }

    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _initializationContractAddress,
        bytes memory _data
    ) internal {
        for (
            uint256 facetIndex;
            facetIndex < _diamondCut.length;
            ++facetIndex
        ) {
            IDiamondCut.FacetCutAction action = _diamondCut[facetIndex].action;

            if (action == IDiamondCut.FacetCutAction.Add) {
                addFunctions(
                    _diamondCut[facetIndex].facetAddress,
                    _diamondCut[facetIndex].functionSelectors
                );
            } else if (action == IDiamondCut.FacetCutAction.Replace) {
                replaceFunctions(
                    _diamondCut[facetIndex].facetAddress,
                    _diamondCut[facetIndex].functionSelectors
                );
            } else if (action == IDiamondCut.FacetCutAction.Remove) {
                removeFunctions(
                    _diamondCut[facetIndex].facetAddress,
                    _diamondCut[facetIndex].functionSelectors
                );
            } else {
                revert Diamond__InvalidFacetAction();
            }
        }

        emit DiamondCut(_diamondCut, _initializationContractAddress, _data);

        initializeDiamondCut(_initializationContractAddress, _data);
    }

    /////////////////////
    /// ADD FUNCTIONS ///
    /////////////////////

    function addFunctions(
        address _facetAddress,
        bytes4[] memory _functionSelectors
    ) internal {
        if (_functionSelectors.length < 0)
            revert Diamond__NoSelectorsInFacetCut();

        DiamondStorage storage ds = diamondStorage();

        if (_facetAddress == address(0)) revert Diamond__InvalidAddressZero();

        uint96 selectorPosition = uint96(
            ds.facetFunctionSelectors[_facetAddress].functionSelectors.length
        );

        if (selectorPosition == 0) addFacet(ds, _facetAddress);

        for (
            uint256 selectorIndex;
            selectorIndex < _functionSelectors.length;
            ++selectorIndex
        ) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = ds
                .selectorToFacetAndPosition[selector]
                .facetAddress;

            if (oldFacetAddress != address(0))
                revert Diamond__FunctionAlreadyExists();

            addFunction(ds, selector, selectorPosition, _facetAddress);

            ++selectorPosition;
        }
    }

    /////////////////////////
    /// REPLACE FUNCTIONS ///
    /////////////////////////

    function replaceFunctions(
        address _facetAddress,
        bytes4[] memory _functionSelectors
    ) internal {
        if (_functionSelectors.length < 0)
            revert Diamond__NoSelectorsInFacetCut();

        DiamondStorage storage ds = diamondStorage();

        if (_facetAddress == address(0)) revert Diamond__InvalidAddressZero();

        uint96 selectorPosition = uint96(
            ds.facetFunctionSelectors[_facetAddress].functionSelectors.length
        );

        if (selectorPosition == 0) addFacet(ds, _facetAddress);

        for (
            uint256 selectorIndex;
            selectorIndex < _functionSelectors.length;
            ++selectorIndex
        ) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = ds
                .selectorToFacetAndPosition[selector]
                .facetAddress;

            if (oldFacetAddress == _facetAddress)
                revert Diamond__SameFunctionAlreadyExists();

            removeFunction(ds, oldFacetAddress, selector);
            addFunction(ds, selector, selectorPosition, _facetAddress);

            ++selectorPosition;
        }
    }

    ////////////////////////
    /// REMOVE FUNCTIONS ///
    ////////////////////////

    function removeFunctions(
        address _facetAddress,
        bytes4[] memory _functionSelectors
    ) internal {
        if (_functionSelectors.length < 0)
            revert Diamond__NoSelectorsInFacetCut();

        DiamondStorage storage ds = diamondStorage();

        if (_facetAddress != address(0))
            revert Diamond__RemoveFacetAddressMustBeZero();

        for (
            uint256 selectorIndex;
            selectorIndex < _functionSelectors.length;
            ++selectorIndex
        ) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = ds
                .selectorToFacetAndPosition[selector]
                .facetAddress;

            removeFunction(ds, oldFacetAddress, selector);
        }
    }

    /////////////////
    /// ADD FACET ///
    /////////////////

    function addFacet(DiamondStorage storage ds, address _facetAddress)
        internal
    {
        enforceHasContractCode(_facetAddress);

        ds.facetFunctionSelectors[_facetAddress].facetAddressPosition = ds
            .facetAddresses
            .length;
        ds.facetAddresses.push(_facetAddress);
    }

    ////////////////////
    /// ADD FUNCTION ///
    ////////////////////

    function addFunction(
        DiamondStorage storage ds,
        bytes4 _selector,
        uint96 _selectorPosition,
        address _facetAddress
    ) internal {
        ds
            .selectorToFacetAndPosition[_selector]
            .functionSelectorPosition = _selectorPosition;
        ds.facetFunctionSelectors[_facetAddress].functionSelectors.push(
            _selector
        );
        ds.selectorToFacetAndPosition[_selector].facetAddress = _facetAddress;
    }

    function removeFunction(
        DiamondStorage storage ds,
        address _facetAddress,
        bytes4 _selector
    ) internal {
        if (_facetAddress == address(0)) revert Diamond__InexistentFunction();

        if (_facetAddress == address(this)) revert Diamond__ImmutableFunction();

        uint256 selectorPosition = ds
            .selectorToFacetAndPosition[_selector]
            .functionSelectorPosition;
        uint256 lastSelectorPositon = ds
            .facetFunctionSelectors[_facetAddress]
            .functionSelectors
            .length - 1;

        if (selectorPosition != lastSelectorPositon) {
            bytes4 lastSelector = ds
                .facetFunctionSelectors[_facetAddress]
                .functionSelectors[lastSelectorPositon];

            ds.facetFunctionSelectors[_facetAddress].functionSelectors[
                    selectorPosition
                ] = lastSelector;
            ds
                .selectorToFacetAndPosition[lastSelector]
                .functionSelectorPosition = uint96(selectorPosition);
        }

        ds.facetFunctionSelectors[_facetAddress].functionSelectors.pop();

        delete ds.selectorToFacetAndPosition[_selector];

        if (lastSelectorPositon == 0) {
            uint256 lastFacetAddressPosition = ds.facetAddresses.length - 1;
            uint256 facetAddressPosition = ds
                .facetFunctionSelectors[_facetAddress]
                .facetAddressPosition;

            if (facetAddressPosition != lastFacetAddressPosition) {
                address lastFacetAddress = ds.facetAddresses[
                    lastFacetAddressPosition
                ];

                ds.facetAddresses[facetAddressPosition] = lastFacetAddress;
                ds
                    .facetFunctionSelectors[lastFacetAddress]
                    .facetAddressPosition = facetAddressPosition;
            }

            ds.facetAddresses.pop();

            delete ds
                .facetFunctionSelectors[_facetAddress]
                .facetAddressPosition;
        }
    }

    //////////////////////////////
    /// INITIALIZE DIAMOND CUT ///
    //////////////////////////////

    function initializeDiamondCut(
        address _initializationContractAddress,
        bytes memory _data
    ) internal {
        if (_initializationContractAddress == address(0)) return;

        enforceHasContractCode(_initializationContractAddress);

        (bool success, bytes memory error) = _initializationContractAddress
            .delegatecall(_data);

        if (!success) {
            if (error.length > 0) {
                assembly {
                    let dataSize := mload(error)

                    revert(add(32, error), dataSize)
                }
            } else {
                revert Diamond__InitializationFailed(
                    _initializationContractAddress,
                    _data
                );
            }
        }
    }

    ///////////////
    /// ENFORCE ///
    ///////////////

    function enforceHasContractCode(address _contract) internal view {
        uint256 contractSize;

        assembly {
            contractSize := extcodesize(_contract)
        }

        if (contractSize < 0) revert Diamond__EmptyContract();
    }

    function enforceIsContractOwner() internal view {
        if (msg.sender != diamondStorage().contractOwner)
            revert Diamond__MustBeOwner();
    }
}
