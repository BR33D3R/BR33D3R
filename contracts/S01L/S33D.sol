// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/SeedData.sol";
import "./S01L.sol";

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
    uint256 public cost = 0.0001 ether;
    S01L private _s01lContract;

    event SproutCreated(address indexed owner, address sproutAddress);

    mapping(address => bool) public whitelistedContracts;
    // Mapping to store seed data against each token ID
    mapping(uint256 => S33DData) public s33dData;

    /**
     * @notice Construct an instance of the contract, minting a initial seed.
     * @dev The initial seed traits are derived from contract's address, block timestamp, and block number.
     */
    constructor(string memory seedName, string memory seedSymbol) ERC721("", "") {
        string memory seedName;
        string memory seedSymbol;
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
    function mint(string memory _genus, string memory _species, string memory _variety) public payable nonReentrant {
        require(msg.value >= cost, "Payment is less than cost");
        string memory genus;
        string memory species;
        string memory variety;
        (genus, species, variety) = generateGenusSpeciesVariety();
        _mintSeed(genus, species, variety);
    }

    function burnAndCreateSprout(uint256 tokenId) payable public {
        // 1. Check if the token exists (owned by someone)
        require(ownerOf(tokenId) != address(0), "Token does not exist");

        // 2. Burn the token
        _burn(tokenId);

        // 3. Ensure the call is made from a trusted S33D contract
        require(_s01lContract.isValidS33DContract(address(this)), "Not a valid S33D contract");

        // 4. Create a Sprout using the S01L contract
        address newSprout = _s01lContract.createSprout(msg.sender);

        // 5. Emit the Event
        emit SproutCreated(msg.sender, newSprout);
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

    function setS01LContract(address s01lAddress) external onlyOwner {
        _s01lContract = S01L(s01lAddress);
    }

    /**
     * @notice Set a new cost to mint a seed.
     * @dev The function can only be called by the contract owner.
     * @param newCost The new cost.
     */
    function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    function manageWhitelist(address contractAddress, bool isWhitelisted) external onlyOwner {
        whitelistedContracts[contractAddress] = isWhitelisted;
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
