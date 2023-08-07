// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/SeedData.sol";

/**
 * @title S33D Contract
 * @notice This contract represents unique seed tokens (S33D) that are ERC721 compliant, burnable, and have additional traits (genus, species, variety).
 * @dev Contract is ownable, ensuring certain actions can only be performed by the contract owner.
 */
contract S33D is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    // Counter for unique token IDs
    Counters.Counter private _tokenIdCounter;

    // Cost to mint a new seed
    uint256 public cost = 0.01 ether;

    // Mapping to store seed data against each token ID
    mapping(uint256 => S33DData) public s33dData;

    /**
     * @notice Construct an instance of the contract, minting a initial seed.
     * @dev The initial seed traits are derived from contract's address, block timestamp, and block number.
     */
    constructor() ERC721("S33D", "S33D") {
        string memory genus;
        string memory species;
        string memory variety;
        (genus, species, variety) = generateGenusSpeciesVariety();
        _mintSeed(genus, species, variety);
    }

    /**
     * @notice Generate a new set of traits for a seed.
     * @dev Traits are formed from the contract's address, block timestamp, and block number.
     * @return The generated genus, species, and variety.
     */
    function generateGenusSpeciesVariety() internal view returns (string memory, string memory, string memory) {
        string memory genus = string(abi.encodePacked("Genus-", address(this)));
        string memory species = string(abi.encodePacked("Species-", block.timestamp));
        string memory variety = string(abi.encodePacked("Variety-", block.number));
        return (genus, species, variety);
    }

    /**
     * @notice Internal function to mint a seed with specific traits.
     * @dev Creates a new seed data and stores it in the s33dData mapping against the token ID.
     * @param _genus The genus of the seed.
     * @param _species The species of the seed.
     * @param _variety The variety of the seed.
     */
    function _mintSeed(string memory _genus, string memory _species, string memory _variety) internal {
        S33DData memory newData = S33DData({
            genus: _genus,
            species: _species,
            variety: _variety
        });

        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        s33dData[newTokenId] = newData;
        _mint(address(this), newTokenId);
    }

    /**
     * @notice Mint a new seed by paying the cost.
     * @dev A seed with new traits is generated and minted. The function reverts if the payment is less than the cost.
     */
    function mint() public payable nonReentrant {
        require(msg.value >= cost, "Payment is less than cost");
        string memory genus;
        string memory species;
        string memory variety;
        (genus, species, variety) = generateGenusSpeciesVariety();
        _mintSeed(genus, species, variety);
    }

    /**
     * @notice Mint multiple new seeds and transfer them to a specific address.
     * @dev The function can only be called by the contract owner.
     * @param to The address to transfer the new seeds.
     * @param amount The number of new seeds to be minted.
     */
    function adminMint(address to, uint256 amount) public onlyOwner {
        for (uint i=0; i<amount; i++) {
            string memory genus;
            string memory species;
            string memory variety;
            (genus, species, variety) = generateGenusSpeciesVariety();
            _mintSeed(genus, species, variety);
            _transfer(address(this), to, _tokenIdCounter.current());
        }
    }

    /**
     * @notice Set a new cost to mint a seed.
     * @dev The function can only be called by the contract owner.
     * @param newCost The new cost.
     */
    function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    /**
     * @notice Withdraw the contract balance to the owner.
     * @dev The function can only be called by the contract owner.
     */
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
