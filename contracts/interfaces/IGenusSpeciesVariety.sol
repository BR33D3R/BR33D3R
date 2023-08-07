// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IGenusSpeciesVariety {
    function generateGenusSpeciesVariety() external view returns (string memory, string memory, string memory);
}