// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Diamond} from "./Diamond.sol";
import {IDiamondCut} from "../interfaces/diamond/IDiamondCut.sol";
import {IDiamondLoupe} from "../interfaces/diamond/IDiamondLoupe.sol";
import {IERC165} from "../interfaces/IERC165.sol";
import {IERC173} from "../interfaces/IERC173.sol";

contract DiamondInit {
    function init() external {
        Diamond.DiamondStorage storage ds = Diamond.diamondStorage();

        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
    }
}
