// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IERC721Receiver
/// @author mektigboy
interface IERC721Receiver {
    /////////////
    /// LOGIC ///
    /////////////

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}
