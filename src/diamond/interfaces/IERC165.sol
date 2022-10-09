// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IERC165
/// @author mektigboy
/// @author Modified from Nick Mudge: https://github.com/mudgen/diamond-3-hardhat
/// @dev EIP-165 standard
interface IERC165 {
    /////////////
    /// LOGIC ///
    /////////////

    /// @notice ...
    /// @param _id Interface ID
    function supportsInterface(bytes4 _id) external view returns (bool);
}
