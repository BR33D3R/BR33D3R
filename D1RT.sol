// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Import necessary contracts and utilities from OpenZeppelin and local contracts.
import "./S33DSFactory.sol";
import "./Sprout.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/**
 * @title D1RT
 * @dev A contract that inherits from ERC721 and implements IERC721Receiver. It allows the user to plant S33Ds and create Sprouts.
 */
contract D1RT is ERC721, IERC721Receiver {

    // Using OpenZeppelin's Counters utility for keeping track of token IDs.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Instance of S33DSFactory.
    S33DSFactory private _s33ds;

    // Mapping to keep track of Sprouts associated with a particular token ID.
    mapping(uint256 => address) public getSprout;

    // Event to notify when a new Sprout is planted.
    event SproutPlanted(address indexed sproutAddress, uint256 indexed sproutId);

    /**
     * @dev Constructor that sets the name and symbol of the ERC721 contract and the S33DSFactory instance.
     */
    constructor(address s33dsAddress) ERC721("D1RT", "D1RT") {
        _s33ds = S33DSFactory(s33dsAddress);
    }

    /**
     * @dev Function to plant a S33D, create a new Sprout, and increment the token ID counter.
     */
    function plantS33D(uint256 tokenId, uint256 _plantType) public {
        require(_s33ds.getApproved(tokenId) == address(this), "D1RT is not approved to transfer this S33D");

        // Transfer the S33D token to this contract.
        _s33ds.safeTransferFrom(msg.sender, address(this), tokenId);

        // Get the S33D token's details.
        address s33dAddress = _s33ds.getS33D(tokenId);
        S33D s33d = S33D(s33dAddress);
        string memory _genus = s33d.genus();
        string memory _species = s33d.species();
        string memory _variety = s33d.variety();
        uint256 _flowerCount = 1; // You need to figure out how to handle this count.

        // Increment the token ID counter and get the new token ID.
        _tokenIdCounter.increment();
        uint256 newSproutId = _tokenIdCounter.current();
        bytes32 saltValue = bytes32(newSproutId);

        // Create a new Sprout contract using Create2 for deterministic deployment.
        address sproutAddress = Create2.deploy(0, saltValue, type(Sprout).creationCode);
        require(sproutAddress != address(0), "Sprout deployment failed");

        // Map the new token ID to the Sprout's address.
        getSprout[newSproutId] = sproutAddress;

        // Initialize the new Sprout contract with the S33D's details.
        Sprout sprout = Sprout(sproutAddress);
        sprout.initialize(msg.sender, _plantType, _flowerCount, _genus, _species, _variety, _s33ds);

        // Burn the S33D token.
        _s33ds.burn(tokenId);

        // Emit the SproutPlanted event.
        emit SproutPlanted(sproutAddress, newSproutId);
    }

    /**
     * @dev Implementation of IERC721Receiver's onERC721Received function. Allows this contract to receive ERC721 tokens.
     */
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
