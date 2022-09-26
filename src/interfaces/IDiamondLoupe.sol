// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IDiamondLoupe
/// @author mektigboy
/// @notice Interface Diamond Loupe
interface IDiamondLoupe {
    /////////////////
    /// STRUCTURE ///
    /////////////////

    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    /////////////
    /// LOGIC ///
    /////////////

    /// @notice Gets facet addresses and their selectors
    function facets() external view returns (Facet[] memory returnedFacets);

    /// @notice Gets selectors supported by a specific facet
    function facetFunctionSelectors(address _facet)
        external
        view
        returns (bytes4[] memory returnedFacetFunctionSelectors);

    /// @notice Gets facet that supports given selector
    function facetAddress(bytes4 _functionSelector)
        external
        view
        returns (address returnedFacetAddress);

    /// @notice Gets all facet addresses used by a diamond
    function facetAddresses()
        external
        view
        returns (address[] memory returnedFacetAddresses);
}
