// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IAuthority
/// @author mektigboy
/// @author Modified from Solmate: https://github.com/transmissions11/solmate
/// @notice A generic interface for a contract which provides authorization data to an Authorizable instance
interface IAuthority {
    /////////////
    /// LOGIC ///
    /////////////

    function canCall(
        address user,
        address target,
        bytes4 functionSig
    ) external view returns (bool);
}
