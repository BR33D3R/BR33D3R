// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Importing OpenZeppelin libraries for safe math, counter, reentrancy protection, ERC721 functionality, and ownership
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IGenusSpeciesVariety.sol"; 
import "../interfaces/SeedData.sol";
import "./S33D.sol";
import "./S01L.sol";

/**
 * @title S33D2 contract
 * @dev Implements the operations of the S33D2 tokens
 */
contract S33D2 is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter; // Using OpenZeppelin utility for handling token IDs

    Counters.Counter private _tokenIdCounter; // Counter for assigning token IDs
    mapping(uint256 => S33DData) public s33dData; // Mapping from token ID to its corresponding data
    uint256 public flowerCount; // The count of flowers
    uint256 public cost = 0 ether; // Cost to mint a token
    S33D private _s33d; // Reference to the S33D contract
    S01L private _s01l; // Reference to the S01L contract

    IGenusSpeciesVariety public genusSpeciesVarietyGenerator; // Interface for GenusSpeciesVariety generator

    event SeedPlanted(uint256 indexed tokenId, address indexed owner); // Event emitted when a seed is planted


    constructor() ERC721("S33D2", "S33D2") {

    }
   
    /**
     * @dev Initialize seeds with the given genus, species, and variety
     * @param _genus Genus of the seed
     * @param _species Species of the seed
     * @param _variety Variety of the seed
     */
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

        function generateGenusSpeciesVariety() internal view returns (string memory, string memory, string memory) {
        string memory genus = string(abi.encodePacked("Genus-", address(this)));
        string memory species = string(abi.encodePacked("Species-", block.timestamp));
        string memory variety = string(abi.encodePacked("Variety-", block.number));
        return (genus, species, variety);
    }



    /**
     * @dev Plants a seed (burns a token)
     * @param tokenId ID of the token to be burned
     */
    function plant(uint256 tokenId) internal {
        super._burn(tokenId);
        emit SeedPlanted(tokenId, msg.sender);
    }

    /**
     * @dev Burn a token and plant a sprout
     * @param tokenId ID of the token to be burned
     */
    function burn(uint256 tokenId) public override nonReentrant onlyOwner {
        require(ownerOf(tokenId) == _msgSender(), "ERC721Burnable: caller is not owner");
        _s01l.burnAndPlant(tokenId);
    }

    /**
     * @dev Mint a new S33D2 token
     * @param to Address to receive the minted tokens
     * @param _genus Genus of the seed
     * @param _species Species of the seed
     * @param _variety Variety of the seed
     */
    function _mintSeed(
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
        _mint(to, newTokenId);
    }

        function mint() public payable nonReentrant {
        require(msg.value >= cost, "Payment is less than cost");
        string memory genus;
        string memory species;
        string memory variety;
        (address to, genus, species, variety) = generateGenusSpeciesVariety();
        _mintSeed(address to, genus, species, variety);
    }

    /**
     * @dev Set the cost to mint a token
     * @param newCost New cost to mint a token
     */
    function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    /**
     * @dev Withdraw all Ether from the contract
     */
    function withdraw() public onlyOwner nonReentrant {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
