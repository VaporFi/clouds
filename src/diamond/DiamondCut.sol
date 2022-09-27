// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/diamond/IDiamondCut.sol";
import {LibDiamond} from "./LibDiamond.sol";

contract DiamondCut is IDiamondCut {
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _initializationContractAddress,
        bytes calldata _data
    ) external override {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.diamondCut(_diamondCut, _initializationContractAddress, _data);
    }
}
