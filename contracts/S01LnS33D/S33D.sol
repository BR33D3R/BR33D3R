// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/SeedData.sol";
import "./S01L.sol";

/**
 * @title S33D Contract
 * @dev This contract represents unique seed tokens (S33D) that are ERC721 compliant and burnable.
 * Each seed token has associated traits (genus, species, variety).
 */
contract S33D is ERC721, ERC721Burnable, Ownable, Pausable, ReentrancyGuard {
	using Counters for Counters.Counter;
	using SafeMath for uint256;
    using Strings for uint256;

	// Counter for unique token IDs
	Counters.Counter private _tokenIdCounter;

	uint256 public cost = 0.0 ether;
	S01L private _s01lContract;
    string private baseURI;

	event SeedMinted(address indexed owner, uint256 indexed tokenId);
	event SeedBurned(uint256 indexed tokenId);
	event SproutCreated(address indexed owner, address indexed sproutAddress);
	event WhitelistUpdated(address indexed contractAddress, bool whitelisted);

	mapping(address => bool) public whitelistedContracts;

	// Mapping to store seed data against each token ID
	mapping(uint256 => S33DData) public s33dData;

	/**
	 * @dev Sets the initial name and symbol for the contract.
	 * @param seedName Name of the seed token.
	 * @param seedSymbol Symbol of the seed token.
	 */
	constructor(
		string memory seedName,
		string memory seedSymbol
	) ERC721(seedName, seedSymbol) {}

	/**
	 * @dev Generate a new set of traits for a seed.
	 * @return The generated genus, species, and variety.
	 */
	function generateGenusSpeciesVariety()
		internal
		view
		returns (string memory, string memory, string memory)
	{
		string memory genus = string(abi.encodePacked("Genus-", address(this)));
		string memory species = string(
			abi.encodePacked("Species-", block.timestamp)
		);
		string memory variety = string(
			abi.encodePacked("Variety-", block.number)
		);
		return (genus, species, variety);
	}

	/**
	 * @dev Mint a new seed with specific traits and assigns it to the contract.
	 * @param _genus Genus of the seed.
	 * @param _species Species of the seed.
	 * @param _variety Variety of the seed.
	 */
	function _mintSeed(
		string memory _genus,
		string memory _species,
		string memory _variety
	) internal {
		S33DData memory newData = S33DData({
			genus: _genus,
			species: _species,
			variety: _variety
		});

		_tokenIdCounter.increment();
		uint256 newTokenId = _tokenIdCounter.current();
		s33dData[newTokenId] = newData;
		_mint(address(this), newTokenId);

		emit SeedMinted(msg.sender, newTokenId);
	}

	/**
	 * @notice Mint a seed by paying the required cost.
	 * @dev A seed is generated and minted. The function reverts if the payment is less than the cost.
	 */
	function mint() public payable nonReentrant whenNotPaused {
		require(msg.value >= cost, "Payment is less than cost");
		string memory genus;
		string memory species;
		string memory variety;
		(genus, species, variety) = generateGenusSpeciesVariety();
		_mintSeed(genus, species, variety);
	}

	/**
	 * @notice Burn a seed and create a sprout.
	 * @param tokenId ID of the seed token to be burned.
	 */
	function burnAndCreateSprout(
		uint256 tokenId
	) external payable whenNotPaused {
		require(ownerOf(tokenId) == msg.sender, "Not the owner of the seed");
		_burn(tokenId);
		emit SeedBurned(tokenId);

		require(
			_s01lContract.isValidS33DContract(address(this)),
			"Not a valid S33D contract"
		);

		address newSprout = _s01lContract.createSprout(msg.sender);

		emit SproutCreated(msg.sender, newSprout);
	}

	/**
	 * @notice Mint multiple seeds and transfer them to a specific address.
	 * @param to Address to receive the minted seeds.
	 * @param amount Number of seeds to mint.
	 */
	function adminMint(address to, uint256 amount) external onlyOwner {
		for (uint i = 0; i < amount; i++) {
			string memory genus;
			string memory species;
			string memory variety;
			(genus, species, variety) = generateGenusSpeciesVariety();
			_mintSeed(genus, species, variety);
			_transfer(address(this), to, _tokenIdCounter.current());
		}
	}

	/**
	 * @notice Set the address of the S01L contract.
	 * @param s01lAddress Address of the S01L contract.
	 */
	function setS01LContract(address s01lAddress) external onlyOwner {
		_s01lContract = S01L(s01lAddress);
	}

	/**
	 * @notice Set the cost to mint a seed.
	 * @param newCost The new cost to set.
	 */
	function setCost(uint256 newCost) external onlyOwner {
		cost = newCost;
	}

	/**
	 * @notice Add or remove contracts from the whitelist.
	 * @param contractAddress Address of the contract.
	 * @param isWhitelisted Boolean indicating whether to whitelist or not.
	 */
	function manageWhitelist(
		address contractAddress,
		bool isWhitelisted
	) external onlyOwner {
		whitelistedContracts[contractAddress] = isWhitelisted;
		emit WhitelistUpdated(contractAddress, isWhitelisted);
	}

	function tokenURI(
		uint256 tokenId
	) public view virtual override returns (string memory) {
		require(
			_exists(tokenId),
			"ERC721Metadata: URI query for nonexistent token"
		);

		string memory base = _baseURI();
		return
			bytes(base).length > 0
				? string(abi.encodePacked(base, Strings.toString(tokenId)))
				: "";
	}

	function pause() public onlyOwner {
		_pause();
	}

	function unpause() public onlyOwner {
		_unpause();
	}

	/**
	 * @notice Withdraw contract balance to the owner's address.
	 */
	// Allows owner to withdraw accumulated funds from contract
	function withdraw() external onlyOwner {
		payable(owner()).transfer(address(this).balance);
	}
}
