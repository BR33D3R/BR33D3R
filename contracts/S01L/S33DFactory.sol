// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; 

/// @title Interface for the S33DSFactory contract.
/// @dev This interface is used to create a new S33D contract.
interface IS33DSFactory {
    function createS33D(string memory _genus, string memory _species, string memory _variety) external;
}

/// @title S33D Contract
/// @dev This contract is an ERC721 token that represents a S33D.
contract S33D is ERC721, Ownable {
    string public genus;
    string public species;
    string public variety;

    constructor() ERC721("S33D", "S33D") {}

    /// @notice Initializes the S33D with its properties.
    /// @param _genus The genus of the S33D.
    /// @param _species The species of the S33D.
    /// @param _variety The variety of the S33D.
    function initialize(string memory _genus, string memory _species, string memory _variety) external onlyOwner {
        genus = _genus;
        species = _species;
        variety = _variety;
    }
}

/// @title S33DSFactory Contract
/// @dev This contract is used to create S33D tokens.
contract S33DSFactory is ERC721, Ownable, IS33DSFactory {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bytes32 public constant S33D_BYTECODE_HASH = keccak256(type(S33D).creationCode);

    mapping(uint256 => address) public getS33D;

    constructor() ERC721("SeedFactory", "SF") {}

    /// @notice Emits when a new S33D is created.
    /// @param s33dAddress The address of the newly deployed S33D contract.
    /// @param tokenId The ID of the new S33D token.
    event S33DCreated(address indexed s33dAddress, uint256 indexed tokenId);

    /// @notice Creates a new S33D token with specified properties.
    /// @dev This function deploys a new S33D contract and mints a new token.
    /// @param _genus The genus of the new S33D.
    /// @param _species The species of the new S33D.
    /// @param _variety The variety of the new S33D.
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
}
