// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Import the Counters library

contract S33D is Ownable {
    // Your custom s33d logic here.
}

contract S33DSFactory is ERC721, Ownable {
    using Counters for Counters.Counter; // Use the Counters library for the Counter type
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant S33D_BYTECODE_HASH = keccak256(type(S33D).creationCode);

    mapping(uint256 => address) public getS33D;

    constructor() ERC721("S33DSFactory", "SF") {}

    function createS33D() public onlyOwner {
        _tokenIdCounter.increment();

        uint256 newItemId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newItemId);

        // Deploy a new S33D contract using Create2 library
        address s33dAddress = Create2.deploy(0, saltValue, type(S33D).creationCode);

        require(s33dAddress != address(0), "S33D deployment failed");

        getS33D[newItemId] = s33dAddress;

        _mint(msg.sender, newItemId);

        emit S33DCreated(s33dAddress, newItemId);
    }

    event S33DCreated(address indexed s33dAddress, uint256 indexed tokenId);
}
