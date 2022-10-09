// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDiamondCut
/// @author mektigboy
/// @author Modified from Nick Mudge: https://github.com/mudgen/diamond-3-hardhat
/// @dev EIP-2535 "Diamond" standard
interface IDiamondCut {
    //////////////
    /// EVENTS ///
    //////////////

    event DiamondCut(FacetCut[] _cut, address _init, bytes _calldata);

    ///////////////
    /// STORAGE ///
    ///////////////

    /// ACTIONS

    /// Add     - 0
    /// Replace - 1
    /// Remove  - 2

    /// @notice Facet actions
    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    /// @param _cut Facet addreses and function selectors
    /// @param _init Address of contract or facet to execute _calldata
    /// @param _calldata Function call, includes function selector and arguments
    function diamondCut(
        FacetCut[] calldata _cut,
        address _init,
        bytes calldata _calldata
    ) external;
}
