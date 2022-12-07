// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error Ownable__OnlyOwner();

/// @title Ownable
/// @author mektigboy
/// @author Modified from Solmate: https://github.com/transmissions11/solmate
/// @notice Simple single owner authorization mixin
abstract contract Ownable {
    //////////////
    /// EVENTS ///
    //////////////

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    /////////////////////////
    /// OWNERSHIP STORAGE ///
    /////////////////////////

    address public owner;

    /////////////////
    /// MODIFIERS ///
    /////////////////

    modifier onlyOwner() virtual {
        if (msg.sender != owner) revert Ownable__OnlyOwner();
        _;
    }

    /////////////
    /// LOGIC ///
    /////////////

    constructor(address _owner) {
        owner = _owner;

        emit OwnershipTransferred(address(0), _owner);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }
}
