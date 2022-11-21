// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title LDiamondLoupeSelectors
/// @author mektigboy
library LDiamondLoupeSelectors {
    ///////////////
    /// STORAGE ///
    ///////////////

    bytes constant encodedSelectors =
        hex"7a0ed627"
        hex"adfca15e"
        hex"52ef6b2c"
        hex"cdffacc6";

    /////////////
    /// LOGIC ///
    /////////////

    /// @notice Get the function selectors
    function selectors() internal pure returns (bytes4[] memory selectors_) {
        uint256 numberOfSelectors = encodedSelectors.length / 4;

        selectors_ = new bytes4[](numberOfSelectors);

        for (uint256 i = 0; i < numberOfSelectors; ) {
            /// @notice Realistically impossible to overflow/underflow
            unchecked {
                ++i;
            }

            uint256 start = i * 4;

            selectors_[i] =
                bytes4(encodedSelectors[start]) |
                (bytes4(encodedSelectors[start + 1]) >> 8) |
                (bytes4(encodedSelectors[start + 2]) >> 16) |
                (bytes4(encodedSelectors[start + 3]) >> 24);
        }
    }
}