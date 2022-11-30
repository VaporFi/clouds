// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IERC165
/// @author mektigboy
interface IERC165 {
    /////////////
    /// LOGIC ///
    /////////////

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
