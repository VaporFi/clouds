// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IAuthority.sol";

error Authorizable__OnlyAuthority();
error Authorizable__OnlyAuthorized();
error Authorizable__OnlyOwner();

/// @title Authorizable
/// @author mektigboy
/// @author Modified from Solmate: https://github.com/transmissions11/solmate
/// @notice Provides a flexible and updatable auth pattern which is completely separate from application logic
abstract contract Authorizable {
    //////////////
    /// EVENTS ///
    //////////////

    event AuthorityUpdated(
        address indexed user,
        IAuthority indexed newAuthority
    );

    event OwnershipTransferred(address indexed user, address indexed newOwner);

    ///////////////
    /// STORAGE ///
    ///////////////

    address public owner;

    IAuthority public authority;

    /////////////////
    /// MODIFIERS ///
    /////////////////

    modifier onlyAuthorized() virtual {
        if (!isAuthorized(msg.sender, msg.sig))
            revert Authorizable__OnlyAuthorized();

        _;
    }

    ///////////////////
    /// CONSTRUCTOR ///
    ///////////////////

    constructor(address _owner, IAuthority _authority) {
        owner = _owner;
        authority = _authority;

        emit OwnershipTransferred(msg.sender, _owner);
        emit AuthorityUpdated(msg.sender, _authority);
    }

    ///////////////////////////
    /// AUTHORIZATION LOGIC ///
    ///////////////////////////

    function isAuthorized(
        address user,
        bytes4 functionSig
    ) internal view virtual returns (bool) {
        IAuthority auth = authority;

        return
            (address(auth) != address(0) &&
                auth.canCall(user, address(this), functionSig)) ||
            user == owner;
    }

    function setAuthority(IAuthority newAuthority) public virtual {
        if (msg.sender != owner) revert Authorizable__OnlyOwner();
        if (!authority.canCall(msg.sender, address(this), msg.sig))
            revert Authorizable__OnlyAuthority();

        authority = newAuthority;

        emit AuthorityUpdated(msg.sender, newAuthority);
    }

    ///////////////////////
    /// OWNERSHIP LOGIC ///
    ///////////////////////

    function transferOwnership(address newOwner) public virtual onlyAuthorized {
        owner = newOwner;

        emit OwnershipTransferred(msg.sender, newOwner);
    }
}
