// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Import the Counters library

contract Seed is Ownable {
    // Your custom seed logic here.
}

contract SeedFactory is ERC721, Ownable {
    using Counters for Counters.Counter; // Use the Counters library for the Counter type
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant SEED_BYTECODE_HASH = keccak256(type(Seed).creationCode);

    mapping(uint256 => address) public getSeed;

    constructor() ERC721("SeedFactory", "SF") {}

    function createSeed() public onlyOwner {
        _tokenIdCounter.increment();

        uint256 newItemId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newItemId);

        // Deploy a new Seed contract using Create2 library
        address seedAddress = Create2.deploy(0, saltValue, type(Seed).creationCode);

        require(seedAddress != address(0), "Seed deployment failed");

        getSeed[newItemId] = seedAddress;

        _mint(msg.sender, newItemId);

        emit SeedCreated(seedAddress, newItemId);
    }

    event SeedCreated(address indexed seedAddress, uint256 indexed tokenId);
}
