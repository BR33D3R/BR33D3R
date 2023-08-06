// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Import the Counters library
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title Interface for the Sprout contract.
/// @dev This interface is used to initialize the sprout contract.
interface ISprout {
    function initialize(address owner, string memory _genus, string memory _species, string memory _variety) external;
}

/// @title Interface for S33DS contract.
/// @dev It is an ERC721 interface with an additional burn function.
interface IS33DS is IERC721 {
    function burn(uint256 tokenId) external;
}

/// @title Sprout Contract
/// @dev This contract is an ERC721 token that represents a sprout.
contract Sprout is ERC721, Ownable, ISprout {
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("Sprout", "SPT") {}

    /// @notice Initializes the sprout with its owner and its properties.
    /// @param owner The address of the owner of the sprout.
    /// @param _genus The genus of the sprout.
    /// @param _species The species of the sprout.
    /// @param _variety The variety of the sprout.
    function initialize(address owner, string memory _genus, string memory _species, string memory _variety) external override {
        transferOwnership(owner);
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

/// @title D1RT Contract
/// @dev This contract is used to plant S33D tokens and create sprout tokens.
contract D1RT is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant SPROUT_BYTECODE_HASH = keccak256(type(Sprout).creationCode);

    mapping(uint256 => address) public getSprout;

    IS33DS private _s33ds;

    /// @notice Initializes the contract with a S33DS contract.
    /// @param s33ds The S33DS contract.
    constructor(IS33DS s33ds) {
    _s33ds = s33ds;
    }

    /// @notice Plants a S33D token and creates a new sprout token.
    /// @dev This function will burn the S33D token and deploy a new Sprout contract with the same properties.
    /// @param tokenId The ID of the S33D token to plant.
    function plantS33D(uint256 tokenId) public {
        _s33ds.safeTransferFrom(msg.sender, address(this), tokenId);
        address s33dAddress = getS33D[tokenId];
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

    /// @notice Confirms the creation of a sprout.
    /// @dev This function will burn the S33D token and deploy a new Sprout contract with the same properties.
    /// @param tokenId The ID of the S33D token to confirm the sprout.
    /// @param _genus The genus of the sprout.
    /// @param _species The species of the sprout.
    /// @param _variety The variety of the sprout.
    function confirmSprout(uint256 tokenId, string memory _genus, string memory _species, string memory _variety) public onlyOwner {
        _tokenIdCounter.increment();

        uint256 newSproutId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newSproutId);

        address sproutAddress = Create2.deploy(0, saltValue, type(Sprout).creationCode);

        require(sproutAddress != address(0), "Sprout deployment failed");

        getSprout[newSproutId] = sproutAddress;

        ISprout(sproutAddress).initialize(msg.sender, _genus, _species, _variety);

        _s33ds.burn(tokenId);

        emit SproutConfirmed(sproutAddress, newSproutId);
    }
    
    /// @notice Emits when a sprout is planted.
    /// @param sproutAddress The address of the newly deployed sprout contract.
    /// @param tokenId The ID of the new sprout token.
    event SproutPlanted(address indexed sproutAddress, uint256 indexed tokenId);

    /// @notice Emits when a sprout is confirmed.
    /// @param sproutAddress The address of the confirmed sprout contract.
    /// @param tokenId The ID of the confirmed sprout token.
    event SproutConfirmed(address indexed sproutAddress, uint256 indexed tokenId);
}
