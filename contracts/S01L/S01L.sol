// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./S33D.sol";
import "./Sprout.sol";

/**
 * @title S01L Contract
 * @notice This contract is responsible for managing the creation of S33D and Sprout contracts. It provides a mapping to keep track of these contracts for easy access.
 * @dev All function calls are currently implemented without side effects
 */
contract S01L is Ownable {
    using Counters for Counters.Counter;
    
    // Counter to keep track of the number of S33D contracts
    Counters.Counter private _contractIdCounter;
    
    // Counter to keep track of the number of Sprout contracts
    Counters.Counter private _sproutIdCounter;

    Sprout private _sprout;

    // Mapping to store the addresses of S33D contracts
    mapping(uint256 => address) public s33dContracts;

    // Mapping to store the addresses of Sprout contracts
    mapping(uint256 => address) public sproutContracts;

    /**
     * @notice Create a new instance of S33D and store its address
     * @dev Requires contract ownership to prevent unauthorized contract creation
     * @return The address of the newly created S33D contract
     */
    function createS33D() public onlyOwner returns (address) {
        // Create a new instance of S33D
        S33D newS33D = new S33D();
        
        // Increment the contract counter
        _contractIdCounter.increment();
        
        // Get the current counter value
        uint256 newContractId = _contractIdCounter.current();
        
        // Store the address of the newly created contract
        s33dContracts[newContractId] = address(newS33D);
        
        // Return the address of the newly created contract
        return address(newS33D);
    }

    /**
     * @notice Create a new instance of Sprout and store its address
     * @dev Requires contract ownership to prevent unauthorized contract creation
     * @return The address of the newly created Sprout contract
     */
    function createSprout() public onlyOwner returns (address) {
        // Create a new instance of Sprout
        Sprout newSprout = new Sprout();
        
        // Increment the sprout counter
        _sproutIdCounter.increment();
        
        // Get the current counter value
        uint256 newSproutId = _sproutIdCounter.current();
        
        // Store the address of the newly created sprout
        sproutContracts[newSproutId] = address(newSprout);
        
        // Return the address of the newly created sprout
        return address(newSprout);
    }

    /**
     * @notice Get the address of a S33D contract given its ID
     * @param contractId The ID of the S33D contract to fetch
     * @return The address of the S33D contract
     */
    function getS33DContract(uint256 contractId) public view returns (address) {
        // Return the address of the requested S33D contract
        return s33dContracts[contractId];
    }

    /**
     * @notice Get the address of a Sprout contract given its ID
     * @param contractId The ID of the Sprout contract to fetch
     * @return The address of the Sprout contract
     */
    function getSproutContract(uint256 contractId) public view returns (address) {
        // Return the address of the requested Sprout contract
        return sproutContracts[contractId];
    }
}
