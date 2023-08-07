// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IGenusSpeciesVariety.sol"; 
import "./interfaces/SeedData.sol";
import "./S33D.sol";

/// @title S33D2 Smart Contract
/// @notice This contract represents unique seed tokens (S33D2) that are ERC721 compliant, burnable, and have additional traits (genus, species, variety).
/// @dev Contract is ownable, ensuring certain actions can only be performed by the contract owner.
contract S33D2 is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => S33DData) public s33dData;
    uint256 public flowerCount;
    uint256 public cost = 0 ether;
    S33D private _s33d;

    IGenusSpeciesVariety public genusSpeciesVarietyGenerator; // Add a state variable to hold the generator contract address

    /// @notice Construct an instance of the contract, minting a number of initial seeds.
    /// @dev The initial seeds do not have their traits assigned yet.
    /// @param _flowerCount The number of initial seeds to mint.
    /// @param _genusSpeciesVarietyGenerator The address of the contract that will generate the seed traits.
    constructor(uint256 _flowerCount, address _genusSpeciesVarietyGenerator) ERC721("S33D2", "S33D2") {
        flowerCount = _flowerCount;
        genusSpeciesVarietyGenerator = IGenusSpeciesVariety(_genusSpeciesVarietyGenerator); // Initialize the generator contract
        for (uint256 i = 0; i < flowerCount; i++) {
            _tokenIdCounter.increment();
            uint256 newTokenId = _tokenIdCounter.current();
            _mint(msg.sender, newTokenId);
        }
    }

    /// @notice Initialize the traits for all initial seeds.
    /// @dev The function can only be called by the contract owner, and can only be called once.
    /// @param _genus The genus of the seeds.
    /// @param _species The species of the seeds.
    /// @param _variety The variety of the seeds.
    function initializeSeeds(
        string memory _genus,
        string memory _species,
        string memory _variety
    ) public onlyOwner {
        require(
            bytes(s33dData[1].genus).length == 0,
            "Seeds have already been initialized"
        );
        for (uint256 i = 1; i <= flowerCount; i++) {
            s33dData[i] = S33DData({
                genus: _genus,
                species: _species,
                variety: _variety
            });
        }
    }

    /// @notice Internal function to mint a seed with specific traits.
    /// @dev Creates a new seed data and stores it in the s33dData mapping against the token ID.
    /// @param to The recipient of the new seed.
    /// @param _genus The genus of the seed.
    /// @param _species The species of the seed.
    /// @param _variety The variety of the seed.
    function _mint(
        address to,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) internal nonReentrant {
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        s33dData[newTokenId] = S33DData({
            genus: _genus,
            species: _species,
            variety: _variety
        });
        _safeMint(to, newTokenId);
    }

    /// @notice Mint a new seed for the owner of the contract.
    /// @dev The function can only be called by the contract owner.
    /// @param to The recipient of the new seed.
    /// @param _genus The genus of the seed.
    /// @param _species The species of the seed.
    /// @param _variety The variety of the seed.
    function mintForOwner(
        address to,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) external onlyOwner {
        _mint(to, _genus, _species, _variety);
    }

    /// @notice Mint a specified amount of new seeds and transfer them to the specified address.
    /// @dev The function can only be called by the contract owner.
    /// @param to The recipient of the new seeds.
    /// @param amount The amount of new seeds to mint.
    /// @param _genus The genus of the seeds.
    /// @param _species The species of the seeds.
    /// @param _variety The variety of the seeds.
    function adminMint(
        address to,
        uint256 amount,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) public onlyOwner {
        for (uint i = 0; i < amount; i++) {
            S33DData memory newData = S33DData({
                genus: _genus,
                species: _species,
                variety: _variety
            });

            _tokenIdCounter.increment();
            uint256 newTokenId = _tokenIdCounter.current();
            s33dData[newTokenId] = newData;
            _mint(to, newTokenId);
        }
    }

    /// @notice Burn a specific token.
    /// @dev The function can only be called by the contract owner.
    /// @param tokenId The ID of the token to burn.
    function burn(uint256 tokenId) public override onlyOwner {
        _burn(tokenId);
    }

    /// @notice Set the cost for minting a new seed.
    /// @dev The function can only be called by the contract owner.
    /// @param newCost The new cost for minting a seed.
    function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    /// @notice Withdraw all funds from the contract to the owner's address.
    /// @dev The function can only be called by the contract owner.
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
