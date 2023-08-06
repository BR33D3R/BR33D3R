// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Exchange is Ownable, ReentrancyGuard {
    // Struct to store the details of each listing.
    struct Listing {
        address tokenAddress;
        uint256 tokenId;
        address seller;
        uint256 price;
    }

    // Array to store all listings.
    Listing[] public listings;

    // Event to notify when a token is listed.
    event TokenListed(address indexed tokenAddress, uint256 indexed tokenId, address indexed seller, uint256 price);

    // Event to notify when a token is bought.
    event TokenBought(address indexed tokenAddress, uint256 indexed tokenId, address indexed buyer, address seller, uint256 price);

    /**
     * @dev Function to list a token for sale.
     */
    function listToken(address tokenAddress, uint256 tokenId, uint256 price) external nonReentrant {
        // Transfer the token from the seller to this contract.
        IERC721(tokenAddress).transferFrom(msg.sender, address(this), tokenId);

        // Create a new listing.
        Listing memory newListing = Listing({
            tokenAddress: tokenAddress,
            tokenId: tokenId,
            seller: msg.sender,
            price: price
        });

        // Add the listing to the listings array.
        listings.push(newListing);

        // Emit the TokenListed event.
        emit TokenListed(tokenAddress, tokenId, msg.sender, price);
    }

    /**
     * @dev Function to buy a token.
     */
    function buyToken(uint256 listingId) external payable nonReentrant {
        // Check that the listingId is valid.
        require(listingId < listings.length, "Invalid listing ID");

        // Get the listing.
        Listing storage listing = listings[listingId];

        // Check that the correct amount has been sent.
        require(msg.value == listing.price, "Incorrect price");

        // Transfer the token from this contract to the buyer.
        IERC721(listing.tokenAddress).transferFrom(address(this), msg.sender, listing.tokenId);

        // Transfer the funds to the seller.
        (bool success, ) = listing.seller.call{value: msg.value}("");
        require(success, "Transfer failed");

        // Remove the listing.
        listings[listingId] = listings[listings.length - 1];
        listings.pop();

        // Emit the TokenBought event.
        emit TokenBought(listing.tokenAddress, listing.tokenId, msg.sender, listing.seller, listing.price);
    }

    /**
     * @dev Function to get the number of listings.
     */
    function getNumberOfListings() external view returns (uint256) {
        return listings.length;
    }

    /**
     * @dev Function to get a listing.
     */
    function getListing(uint256 listingId) external view returns (address, uint256, address, uint256) {
        require(listingId < listings.length, "Invalid listing ID");

        Listing storage listing = listings[listingId];

        return (listing.tokenAddress, listing.tokenId, listing.seller, listing.price);
    }
}
