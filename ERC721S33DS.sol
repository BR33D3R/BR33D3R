// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; 

interface IS33D {
    function initialize(string memory _genus, string memory _species, string memory _variety) external;
}

contract S33D is ERC721, Ownable, IS33D {
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("S33D", "S33D") {}

    function initialize(string memory _genus, string memory _species, string memory _variety) external override onlyOwner {
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

contract S33DSFactory is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant S33D_BYTECODE_HASH = keccak256(type(S33D).creationCode);

    mapping(uint256 => address) public getS33D;

    constructor() ERC721("SeedFactory", "SF") {}

    function createS33D(string memory _genus, string memory _species, string memory _variety) public onlyOwner {
        _tokenIdCounter.increment();

        uint256 newItemId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newItemId);

        address s33dAddress = Create2.deploy(0, saltValue, type(S33D).creationCode);

        require(s33dAddress != address(0), "S33D deployment failed");

        getS33D[newItemId] = s33dAddress;

        IS33D(s33dAddress).initialize(_genus, _species, _variety);

        _mint(msg.sender, newItemId);

        emit S33DCreated(s33dAddress, newItemId);
    }

    event S33DCreated(address indexed s33dAddress, uint256 indexed tokenId);
}
