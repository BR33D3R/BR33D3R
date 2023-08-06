// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing necessary modules from OpenZeppelin library.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; 

/**
 * @title IS33DSFactory
 * @dev This interface allows to create a new S33D.
 */
interface IS33DSFactory {
    function createS33D(string memory _genus, string memory _species, string memory _variety) external;
}

/**
 * @title S33D
 * @dev This contract represents a seed, which includes genus, species, and variety of the plant. Inherits from ERC721 and Ownable.
 */
contract S33D is ERC721, Ownable {
    // These string variables store information about the plant's genus, species, and variety.
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("S33D", "S33D") {}

    /**
     * @dev Initializes the S33D with a plant genus, species, and variety. Can only be called by the owner.
     */
    function initialize(string memory _genus, string memory _species, string memory _variety) external  onlyOwner {
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

/**
 * @title S33DSFactory
 * @dev This contract allows to create, store and burn S33D tokens. Inherits from ERC721, ERC721Burnable, Ownable and implements IS33DSFactory.
 */
contract S33DSFactory is ERC721, ERC721Burnable, Ownable, IS33DSFactory {
    using Counters for Counters.Counter;
    // Counter for generating unique token IDs.
    Counters.Counter private _tokenIdCounter;

    // Hash of the S33D contract bytecode.
    bytes32 public constant S33D_BYTECODE_HASH = keccak256(type(S33D).creationCode);

    // Mapping from token ID to corresponding deployed S33D contract address.
    mapping(uint256 => address) public getS33D;

    constructor() ERC721("SeedFactory", "SF") {}

    event S33DCreated(address indexed s33dAddress, uint256 indexed tokenId);

    /**
     * @dev Creates a new S33D, initializes it with plant details, mints a new token and assigns it to the owner. Emits a S33DCreated event.
     */
    function createS33D(string memory _genus, string memory _species, string memory _variety) public override onlyOwner {
        _tokenIdCounter.increment();

        // Generate a new unique token ID.
        uint256 newItemId = _tokenIdCounter.current();
        // Create a unique salt from the token ID for creating a new S33D contract.
        bytes32 saltValue = bytes32(newItemId);

        // Deploy a new S33D contract using Create2 for the same predictable address.
        address s33dAddress = Create2.deploy(0, saltValue, type(S33D).creationCode);

        // Check if S33D contract deployed successfully.
        require(s33dAddress != address(0), "S33D deployment failed");

        // Store the deployed S33D contract address against the token ID.
        getS33D[newItemId] = s33dAddress;

        // Initialize the deployed S33D contract with plant details.
        S33D(s33dAddress).initialize(_genus, _species, _variety);

        // Mint a new token for the sender with the new unique token ID.
        _mint(msg.sender, newItemId);

        // Emit event that a new S33D contract has been created.
        emit S33DCreated(s33dAddress, newItemId);
    }

    /**
     * @dev Burns a token, removing it from the owner. Then, renounces ownership of the contract to the 0x0 burn address.
     */
    function burn(uint256 tokenId) public override {
        // Check if token exists before burning.
        require(_exists(tokenId), "ERC721Burnable: operator query for nonexistent token");

        // Call OpenZeppelin's burn function to burn the token.
        super.burn(tokenId);

        // Renounce ownership of the contract to the 0x0 burn address.
        transferOwnership(address(0));
    }
}
