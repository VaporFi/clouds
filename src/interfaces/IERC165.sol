// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC165
/// @author mektigboy
/// @notice
/// @dev
interface IERC165 {
    /////////////////
    /// INTERFACE ///
    /////////////////

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
