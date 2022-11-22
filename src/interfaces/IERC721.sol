// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title IERC721
/// @author mejiasd3v, mektigboy
interface IERC721 {
    //////////////
    /// EVENTS ///
    //////////////

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /////////////
    /// LOGIC ///
    /////////////

    function approve(address to, uint256 tokenId) external;

    function balanceOf(address owner) external view returns (uint256 balance);

    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}
