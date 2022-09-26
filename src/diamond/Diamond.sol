// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/diamond/IDiamondCut.sol";

error Diamond__InitializationFailed(
    address initializationContractAddress,
    bytes data
);
error Diamond__InvalidFacetAction();
error Diamond__OnlyOwner();

contract Diamond {
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

    function diamondStorage()
        internal
        pure
        returns (DiamondStorage storage returnedDiamondStorage)
    {
        bytes32 position = DIAMOND_STORAGE_POSITION;

        assembly {
            returnedDiamondStorage.slot := position
        }
    }

    function setContractOwner(address _newOwner) internal {
        DiamondStorage storage ds = diamondStorage();

        address oldOwner = ds.contractOwner;

        ds.contractOwner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function contractOwner()
        internal
        view
        returns (address returnedContractOwner)
    {
        returnedContractOwner = diamondStorage().contractOwner;
    }

    function enforceIsContractOwner() internal view {
        if (msg.sender != diamondStorage().contractOwner)
            revert Diamond__OnlyOwner();
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
                )
            } else {
                revert Diamond__InvalidFacetAction();
            }
        }
    }
}
