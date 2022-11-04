// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC173
/// @author mektigboy
interface IERC173 {
    //////////////
    /// EVENTS ///
    //////////////

    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    /////////////
    /// LOGIC ///
    /////////////

    function owner() external view returns (address owner);

    function transferOwnership(address owner) external;
}
