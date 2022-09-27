// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondLoupe} from "../interfaces/diamond/IDiamondLoupe.sol";
import {IERC165} from "../interfaces/IERC165.sol";
import {LibDiamond} from "./LibDiamond.sol";

abstract contract DiamondLoupe is IDiamondLoupe, IERC165 {
    function facets() external view override returns (Facet[] memory f) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        uint256 numberOfFacets = ds.facetAddresses.length;

        f = new Facet[](numberOfFacets);

        for (uint256 i; i < numberOfFacets; ++i) {
            address fa = ds.facetAddresses[i];

            f[i].facetAddress = fa;
            f[i].functionSelectors = ds
                .facetFunctionSelectors[fa]
                .functionSelectors;
        }
    }

    function facetFunctionSelectors(address _facet)
        external
        view
        override
        returns (bytes4[] memory ffs)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        ffs = ds.facetFunctionSelectors[_facet].functionSelectors;
    }

    function facetAddresses()
        external
        view
        override
        returns (address[] memory fas)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        fas = ds.facetAddresses;
    }

    function facetAddress(bytes4 _functionSelector)
        external
        view
        override
        returns (address fa)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        fa = ds.selectorToFacetAndPosition[_functionSelector].facetAddress;
    }

    function supportsInterface(bytes4 _interfaceId)
        external
        view
        override
        returns (bool)
    {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        return ds.supportedInterfaces[_interfaceId];
    }
}
