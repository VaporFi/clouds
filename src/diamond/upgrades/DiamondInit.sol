// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../LDiamond.sol";
import "../interfaces/IDiamondCut.sol";
import "../interfaces/IDiamondLoupe.sol";
import "../interfaces/IERC165.sol";
import "../interfaces/IERC173.sol";

/// @title DiamondInit
/// @author mektigboy
/// @author Modified from Nick Mudge: https://github.com/mudgen/diamond-3-hardhat
contract DiamondInit {
    /////////////
    /// LOGIC ///
    /////////////

    /// @notice
    function init() external {
        LDiamond.DiamondStorage storage ds = LDiamond.diamondStorage();

        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
    }
}
