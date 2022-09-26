// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IDiamondCut
/// @author mektigboy
/// @notice Interface Diamond Cut
interface IDiamondCut {
    //////////////
    /// EVENTS ///
    //////////////

    event DiamondCut(FacetCut[] diamondCut, address initializationContractAddress, bytes data);

    ///////////////
    /// ACTIONS ///
    ///////////////

    /// Add - 0
    /// Replace - 1
    /// Remove - 2

    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    /////////////////
    /// STRUCTURE ///
    /////////////////

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    /////////////
    /// LOGIC ///
    /////////////

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _initializationContractAddress,
        bytes calldata _data
    ) external;
}
