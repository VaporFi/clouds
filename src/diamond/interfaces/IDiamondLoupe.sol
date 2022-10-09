// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDiamondLoupe
/// @author mektigboy
/// @author Modified from Nick Mudge: https://github.com/mudgen/diamond-3-hardhat
/// @dev EIP-2535 "Diamond" standard
interface IDiamondLoupe {
    ///////////////
    /// STORAGE ///
    ///////////////

    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    /////////////
    /// LOGIC ///
    /////////////

    /// @notice ...
    function facets() external view returns (Facet[] memory facets_);

    /// @notice ...
    /// @param _facet Facet address
    function facetFunctionSelectors(address _facet)
        external
        view
        returns (bytes4[] memory facetFunctionSelectors_);

    /// @notice ...
    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    /// @notice ...
    /// @param _selector Function selector
    function facetAddress(bytes4 _selector)
        external
        view
        returns (address facetAddress_);
}
