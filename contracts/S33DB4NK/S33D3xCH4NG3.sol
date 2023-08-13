// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract S33D3xCH4NGE is Ownable, ReentrancyGuard {

    struct Listing {
        address tokenAddress;
        uint256 tokenId;
        address seller;
        uint256 price;
    }

    Listing[] public listings;

    event TokenListed(address indexed tokenAddress, uint256 indexed tokenId, address indexed seller, uint256 price);
    event TokenBought(address indexed tokenAddress, uint256 indexed tokenId, address indexed buyer, address seller, uint256 price);

    function listToken(address tokenAddress, uint256 tokenId, uint256 price) external nonReentrant {
        IERC721(tokenAddress).transferFrom(msg.sender, address(this), tokenId);

        Listing memory newListing = Listing({
            tokenAddress: tokenAddress,
            tokenId: tokenId,
            seller: msg.sender,
            price: price
        });

        listings.push(newListing);
        emit TokenListed(tokenAddress, tokenId, msg.sender, price);
    }

    function buyToken(uint256 listingId) external payable nonReentrant {
        require(listingId < listings.length, "Invalid listing ID");

        Listing storage listing = listings[listingId];
        require(msg.value == listing.price, "Incorrect price");

        IERC721(listing.tokenAddress).transferFrom(address(this), msg.sender, listing.tokenId);

        payable(listing.seller).transfer(msg.value);

        listings[listingId] = listings[listings.length - 1];
        listings.pop();

        emit TokenBought(listing.tokenAddress, listing.tokenId, msg.sender, listing.seller, listing.price);
    }

    function getNumberOfListings() external view returns (uint256) {
        return listings.length;
    }

    function getListing(uint256 listingId) external view returns (address, uint256, address, uint256) {
        require(listingId < listings.length, "Invalid listing ID");
        Listing storage listing = listings[listingId];
        return (listing.tokenAddress, listing.tokenId, listing.seller, listing.price);
    }
}
