// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC721.sol";

/// @title IERC721Metadata
/// @author mejiasd3v, mektigboy
interface IERC721Metadata is IERC721 {
    /////////////
    /// LOGIC ///
    /////////////

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}
