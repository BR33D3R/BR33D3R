// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Importing OpenZeppelin libraries for safe math, counter, reentrancy protection, ERC721 functionality, and ownership
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/SeedData.sol";
import "./S01L.sol";

/**
 * @title S33D contract
 * @dev Implements the operations of the S33D tokens
 */
contract S33D is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter; // Using OpenZeppelin utility for handling token IDs
    using SafeMath for uint256; // Using OpenZeppelin utility for safe math operations

    Counters.Counter private _tokenIdCounter; // Counter for assigning token IDs
    uint256 public cost = 0.0 ether; // Cost to mint a token

    // Mapping from token ID to its corresponding data
    mapping(uint256 => S33DData) public s33dData;
    S01L private _s01l; // Reference to the S01L contract

    /**
     * @dev Contract constructor
     * @param s01l address of the S01L contract
     */
    constructor(S01L s01l) ERC721("S33D", "S33D") {
        _s01l = s01l;
        string memory genus;
        string memory species;
        string memory variety;
        (genus, species, variety) = generateGenusSpeciesVariety();
        _mintSeed(genus, species, variety);
    }

    event SeedPlanted(uint256 indexed tokenId, address indexed owner); // Event emitted when a seed is planted

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
    function burn(uint256 tokenId) public override nonReentrant {
        require(ownerOf(tokenId) == _msgSender(), "ERC721Burnable: caller is not owner");
        _s01l.burnAndPlant(tokenId); // Call the function to burn token and plant a sprout.
    }

    /**
     * @dev Generate the Genus, Species and Variety for a token
     * @return A tuple containing genus, species, and variety
     */
    function generateGenusSpeciesVariety() internal view returns (string memory, string memory, string memory) {
        string memory genus = string(abi.encodePacked("Genus-", address(this)));
        string memory species = string(abi.encodePacked("Species-", block.timestamp));
        string memory variety = string(abi.encodePacked("Variety-", block.number));
        return (genus, species, variety);
    }

    /**
     * @dev Mint a new S33D token
     * @param _genus Genus of the seed
     * @param _species Species of the seed
     * @param _variety Variety of the seed
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
     * @dev Public function to mint a new S33D token
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
     * @dev Mint new tokens and transfer them to a specific address
     * @param to Address to receive the minted tokens
     * @param amount Number of tokens to mint
     */
    function adminMint(address to, uint256 amount) external onlyOwner {
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
