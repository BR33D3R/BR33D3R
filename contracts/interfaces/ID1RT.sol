// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


interface ID1RT {
    function sproutImplementation() external view returns (address);
    function updateSproutImplementation(address newImplementation) external;
}
