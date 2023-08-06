// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";

/**
 * @title ExchangeFactory
 * @dev This contract allows for the creation of new exchange contracts.
 */
contract ExchangeFactory {

    // The address of the Exchange implementation.
    address private _exchangeImplementation;

    // Mapping from Sprout token ID to corresponding Exchange contract address.
    mapping(uint256 => address) public getExchange;

    // Event to notify when a new Exchange is created.
    event ExchangeCreated(address indexed exchangeAddress, uint256 indexed sproutId);

    /**
     * @dev Constructor that sets the Exchange implementation address.
     */
    constructor(address exchangeImplementation) {
        _exchangeImplementation = exchangeImplementation;
    }

    /**
     * @dev Function to create a new Exchange for a given Sprout token.
     */
    function createExchange(uint256 sproutId) external {
        require(getExchange[sproutId] == address(0), "Exchange for this Sprout token already exists");

        // Clone the Exchange contract.
        address exchangeAddress = Clones.clone(_exchangeImplementation);

        // Initialize the new Exchange contract with the Sprout token ID.
        IExchange(exchangeAddress).initialize(sproutId);

        // Map the Sprout token ID to the Exchange's address.
        getExchange[sproutId] = exchangeAddress;

        // Emit the ExchangeCreated event.
        emit ExchangeCreated(exchangeAddress, sproutId);
    }

    /**
     * @dev Returns the address of the Exchange implementation.
     */
    function exchangeImplementation() external view returns (address) {
        return _exchangeImplementation;
    }

    /**
     * @dev Updates the address of the Exchange implementation. Can only be called by the contract owner.
     */
    function updateExchangeImplementation(address newImplementation) external {
        _exchangeImplementation = newImplementation;
    }
}

/**
 * @title IExchange
 * @dev This interface allows to initialize a new Exchange.
 */
interface IExchange {
    function initialize(uint256 sproutId) external;
}
