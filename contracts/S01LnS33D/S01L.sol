// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

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
	uint256 public cost = 0.0 ether;

	// Mapping to track parent-child relationship
	mapping(address => address) public parentChildRelationship;

	// Mapping to store the addresses of S33D contracts
	mapping(uint256 => address) public s33dContracts;

	// Mapping to store the addresses of Sprout contracts
	mapping(uint256 => address) public sproutContracts;

	mapping(address => bool) public trustedContracts;

	// Events
	event TrustedContractAdded(address indexed contractAddress);
	event TrustedContractRemoved(address indexed contractAddress);
	event S33DContractCreated(
		address indexed contractAddress,
		uint256 contractId
	);
	event SproutContractCreated(
		address indexed contractAddress,
		uint256 sproutId,
		address parent
	);

	modifier onlyTrustedContracts() {
		require(
			trustedContracts[msg.sender],
			"Caller is not a trusted contract"
		);
		_;
	}

	function addTrustedContract(address _contract) internal {
		trustedContracts[_contract] = true;
		emit TrustedContractAdded(_contract);
	}

	function removeTrustedContract(address _contract) public onlyOwner {
		trustedContracts[_contract] = false;
		emit TrustedContractRemoved(_contract);
	}

	/**
	 * @notice Create a new instance of S33D and store its address
	 * @dev Requires contract ownership to prevent unauthorized contract creation
	 * @return The address of the newly created S33D contract
	 */
    function S0WS33D(string memory seedName, string memory seedSymbol) public payable returns (address) {
        require(cost == msg.value);
        S33D newS33D = new S33D(seedName, seedSymbol); 

        // Transfer ownership of the newly created S33D contract to msg.sender
        newS33D.transferOwnership(msg.sender);

        // Increment the contract counter
        _contractIdCounter.increment();

        // Get the current counter value
        uint256 newContractId = _contractIdCounter.current();

        // Store the address of the newly created contract
        s33dContracts[newContractId] = address(newS33D);

        // Grant the newly created S33D contract the trusted role
        addTrustedContract(address(newS33D));

        emit S33DContractCreated(address(newS33D), newContractId);

        // Return the address of the newly created contract
        return address(newS33D);
    }

	function createSprout(address newOwner) public onlyTrustedContracts returns  (address) {
		require(trustedContracts[msg.sender], "Caller is not a trusted S33D contract");
        // Create a new instance of Sprout
		Sprout newSprout = new Sprout();

		// Transfer ownership of the newly created Sprout contract to newOwner
		newSprout.transferOwnership(newOwner);

		// Update parent-child relationship if the sender is a Sprout
		parentChildRelationship[msg.sender] = address(newSprout);
		

		// Increment the sprout counter
		_sproutIdCounter.increment();

		// Get the current counter value
		uint256 newSproutId = _sproutIdCounter.current();

		// Store the address of the newly created sprout
		sproutContracts[newSproutId] = address(newSprout);

		emit SproutContractCreated(address(newSprout), newSproutId, msg.sender);

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
	function getSproutContract(
		uint256 contractId
	) public view returns (address) {
		// Return the address of the requested Sprout contract
		return sproutContracts[contractId];
	}

    function isValidS33DContract(address _contract) public view returns (bool) {
            return trustedContracts[_contract];
        }

	/**
	 * @notice Get the ID of the last created S33D contract
	 * @return The ID of the last created S33D contract
	 */
	function getLastS33DContractId() public view returns (uint256) {
		return _contractIdCounter.current();
	}

	/**
	 * @notice Get the address of the last created S33D contract
	 * @return The address of the last created S33D contract
	 */
	function getLastS33DContract() public view returns (address) {
		uint256 lastId = getLastS33DContractId();
		return s33dContracts[lastId];
	}

	/**
	 * @notice Get the ID of the last created Sprout contract
	 * @return The ID of the last created Sprout contract
	 */
	function getLastSproutId() public view returns (uint256) {
		return _sproutIdCounter.current();
	}

	/**
	 * @notice Get the address of the last created Sprout contract
	 * @return The address of the last created Sprout contract
	 */
	function getLastSproutContract() public view returns (address) {
		uint256 lastId = getLastSproutId();
		return sproutContracts[lastId];
	}
}
