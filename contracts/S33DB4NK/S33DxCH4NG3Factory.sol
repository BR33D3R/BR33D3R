// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/Clones.sol";


interface IExchange {
    function initialize(uint256 sproutId) external;
}
contract S33DxCH4NG3Factory {
    address private _exchangeImplementation;
    mapping(uint256 => address) public getExchange;

    event ExchangeCreated(address indexed exchangeAddress, uint256 indexed sproutId);

    constructor(address exchangeImplementation) {
        _exchangeImplementation = exchangeImplementation;
    }

    function createExchange(uint256 sproutId) external {
        require(getExchange[sproutId] == address(0), "Exchange exists");
        address exchangeAddress = Clones.clone(_exchangeImplementation);
        IExchange(exchangeAddress).initialize(sproutId);
        getExchange[sproutId] = exchangeAddress;
        emit ExchangeCreated(exchangeAddress, sproutId);
    }
}

