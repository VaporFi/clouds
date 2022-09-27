// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC173
/// @author mektigboy
/// @notice
/// @dev
interface IERC173 {
    //////////////
    /// EVENTS ///
    //////////////

    event OwnershipTransferred(
        address indexed oldOwner,
        address indexed newOwner
    );

    /////////////////
    /// OWNERSHIP ///
    /////////////////

    function owner() external view returns (address o);

    function transferOwnership(address _newOwner) external;
}
