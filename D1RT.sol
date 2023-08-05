// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Import the Counters library
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ISprout {
    function initialize(address owner, string memory _genus, string memory _species, string memory _variety) external;
}

interface IS33DS is IERC721 {
    function burn(uint256 tokenId) external;
}


contract Sprout is ERC721, Ownable, ISprout {
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("Sprout", "SPT") {}

    function initialize(address owner, string memory _genus, string memory _species, string memory _variety) external override {
        transferOwnership(owner);
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

contract D1RT is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // This will be the address of the deployed S33DSFactory contract


    bytes32 public constant SPROUT_BYTECODE_HASH = keccak256(type(Sprout).creationCode);

    mapping(uint256 => address) public getSprout;

    IS33DS private _s33ds;

    constructor(IS33DS s33ds) {
    _s33ds = s33ds;
    }

function plantS33D(uint256 tokenId) public {
    _s33ds.safeTransferFrom(msg.sender, address(this), tokenId);
    // Get the S33D contract address from the token ID
    address s33dAddress = getS33D[tokenId];
    // Get the seed's properties
    IS33D s33d = IS33D(s33dAddress);
    string memory _genus = s33d.genus();
    string memory _species = s33d.species();
    string memory _variety = s33d.variety();

    _tokenIdCounter.increment();
    uint256 newSproutId = _tokenIdCounter.current();
    bytes32 saltValue = bytes32(newSproutId);

    address sproutAddress = Create2.deploy(0, saltValue, type(Sprout).creationCode);

    require(sproutAddress != address(0), "Sprout deployment failed");

    getSprout[newSproutId] = sproutAddress;

    ISprout(sproutAddress).initialize(msg.sender, _genus, _species, _variety, _type, _flowerCount);

    _s33ds.burn(tokenId);

    emit SproutPlanted(sproutAddress, newSproutId);
    }

    function confirmSprout(uint256 tokenId, string memory _genus, string memory _species, string memory _variety) public onlyOwner {
        _tokenIdCounter.increment();

        uint256 newSproutId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newSproutId);

        // Deploy a new Sprout contract using Create2 library
        address sproutAddress = Create2.deploy(0, saltValue, type(Sprout).creationCode);

        require(sproutAddress != address(0), "Sprout deployment failed");

        getSprout[newSproutId] = sproutAddress;

        ISprout(sproutAddress).initialize(msg.sender, _genus, _species, _variety);

        _s33ds.burn(tokenId);

        emit SproutConfirmed(sproutAddress, newSproutId);
    }
    event SproutPlanted(address indexed sproutAddress, uint256 indexed tokenId);
    event SproutConfirmed(address indexed sproutAddress, uint256 indexed tokenId);
}
