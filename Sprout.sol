// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; 

interface IS33DSFactory {
    function createS33D(string memory _genus, string memory _species, string memory _variety) external;
}

contract S33D is ERC721, Ownable {
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("S33D", "S33D") {}

    function initialize(string memory _genus, string memory _species, string memory _variety) external  onlyOwner {
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

contract S33DSFactory is ERC721, ERC721Burnable, Ownable, IS33DSFactory {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant S33D_BYTECODE_HASH = keccak256(type(S33D).creationCode);

    mapping(uint256 => address) public getS33D;

    constructor() ERC721("SeedFactory", "SF") {}

    event S33DCreated(address indexed s33dAddress, uint256 indexed tokenId);

    function createS33D(string memory _genus, string memory _species, string memory _variety) public override onlyOwner {
        _tokenIdCounter.increment();

        uint256 newItemId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newItemId);

        address s33dAddress = Create2.deploy(0, saltValue, type(S33D).creationCode);

        require(s33dAddress != address(0), "S33D deployment failed");

        getS33D[newItemId] = s33dAddress;

        S33D(s33dAddress).initialize(_genus, _species, _variety);

        _mint(msg.sender, newItemId);

        emit S33DCreated(s33dAddress, newItemId);
    }

    function burn(uint256 tokenId) public override {
        require(_exists(tokenId), "ERC721Burnable: operator query for nonexistent token");

        // Call OpenZeppelin's burn
        super.burn(tokenId);

        // Renounce ownership of the contract to the 0x0 burn address
        transferOwnership(address(0));
    }
}
