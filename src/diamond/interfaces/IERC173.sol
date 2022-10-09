// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IERC173
/// @author mektigboy
/// @author Modified from Nick Mudge: https://github.com/mudgen/diamond-3-hardhat
/// @dev EIP-173 standard
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

    /// @notice Gets address of owner
    function owner() external view returns (address owner_);

    /// @notice Sets address of new owner
    function transferOwnership(address _newOwner) external;
}
