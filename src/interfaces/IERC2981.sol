// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IERC2981
/// @author mektigboy
interface IERC2981 {
    //////////////
    /// EVENTS ///
    //////////////

    event DefaultRoyalty(
        address indexed newRoyaltyRecipient,
        uint256 newRoyaltyBps
    );

    event RoyaltyForToken(
        uint256 indexed tokenId,
        address indexed royaltyRecipient,
        uint256 royaltyBps
    );

    /////////////
    /// LOGIC ///
    /////////////

    function royaltyInfo(
        uint256 tokenId,
        uint256 salePrice
    ) external view returns (address receiver, uint256 royaltyAmount);
}
