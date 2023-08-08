// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Counters.sol";

library S01LLibrary {
    using Counters for Counters.Counter;

    struct Data {
        Counters.Counter contractIdCounter;
        Counters.Counter sproutIdCounter;
        mapping(uint256 => address) s33dContracts;
        mapping(uint256 => address) sproutContracts;
        mapping(address => bool) whitelistedContracts;
    }

    function getContractIdCounter(Data storage self) public view returns (uint256) {
        return self.contractIdCounter.current();
    }

    function getSproutIdCounter(Data storage self) public view returns (uint256) {
        return self.sproutIdCounter.current();
    }

    function getS33DContract(Data storage self, uint256 contractId) public view returns (address) {
        return self.s33dContracts[contractId];
    }

    function getSproutContract(Data storage self, uint256 contractId) public view returns (address) {
        return self.sproutContracts[contractId];
    }
    function addS33DContract(Data storage self, address s33d) public {
        self.contractIdCounter.increment();
        uint256 newContractId = self.contractIdCounter.current();
        self.s33dContracts[newContractId] = s33d;
        self.whitelistedContracts[s33d] = true;
    }

    function isWhitelisted(Data storage self, address contractAddress) public view returns (bool) {
        return self.whitelistedContracts[contractAddress];
    }

    function plantSprout(Data storage self, address sproutAddress) public returns (address) {
        self.sproutIdCounter.increment();
        uint256 newSproutId = self.sproutIdCounter.current();
        self.sproutContracts[newSproutId] = sproutAddress;
        return sproutAddress;
    }
    
}
