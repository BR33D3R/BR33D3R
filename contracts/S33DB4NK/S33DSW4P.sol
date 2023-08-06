// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title CombinedExchange
 * @dev A contract to swap both ERC20 tokens and ERC721 tokens.
 */
contract CombinedExchange {
    // ERC20 functionality
    struct ERC20Pool {
        IERC20 token0;
        IERC20 token1;
        uint reserve0;
        uint reserve1;
    }

    // Mapping of ERC20 pools
    mapping(address => ERC20Pool) public erc20Pools;

    // Blacklist for ERC20 tokens
    mapping(address => bool) public erc20Blacklist;

    // ERC721 functionality
    struct Offer {
        address offeror;
        address nftAddress;
        uint256 tokenId;
    }

    // Mapping of swap offers
    mapping(uint256 => Offer) public swapOffers;
    uint256 public nextSwapOfferId;

    // List of supported NFT contracts
    mapping(address => bool) public supportedNFTs;

    // Event that will be emitted whenever a new swap offer is created
    event SwapOfferCreated(uint256 indexed swapOfferId, address indexed offeror, address nftAddress, uint256 indexed tokenId);

    // Event that will be emitted whenever a swap offer is executed
    event SwapOfferExecuted(uint256 indexed swapOfferId, address indexed executor, address nftAddress, uint256 indexed tokenId);

    /**
     * @dev Create a new ERC20 token pool.
     * @param _token0 The address of the first token.
     * @param _token1 The address of the second token.
     */
    function createPool(address _token0, address _token1) public {
        require(erc20Blacklist[_token0] == false && erc20Blacklist[_token1] == false, "One or both tokens are blacklisted");

        erc20Pools[_token0] = ERC20Pool({
            token0: IERC20(_token0),
            token1: IERC20(_token1),
            reserve0: 0,
            reserve1: 0
        });
    }

    /**
     * @dev Create a new swap offer for ERC721 tokens.
     * @param _nftAddress The address of the NFT contract.
     * @param _tokenId The ID of the NFT.
     */
    function createSwapOffer(address _nftAddress, uint256 _tokenId) public {
        require(supportedNFTs[_nftAddress], "NFT not supported");

        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == msg.sender, "Caller is not the owner of this NFT");
        require(nft.getApproved(_tokenId) == address(this), "Contract is not approved to transfer this NFT");

        uint256 swapOfferId = nextSwapOfferId;
        nextSwapOfferId++;

        swapOffers[swapOfferId] = Offer({
            offeror: msg.sender,
            nftAddress: _nftAddress,
            tokenId: _tokenId
        });

        emit SwapOfferCreated(swapOfferId, msg.sender, _nftAddress, _tokenId);
    }

    /**
     * @dev Execute a swap offer for ERC721 tokens.
     * @param _swapOfferId The ID of the swap offer.
     * @param _nftAddress The address of the NFT contract.
     * @param _tokenId The ID of the NFT.
     */
    function executeSwapOffer(uint256 _swapOfferId, address _nftAddress, uint256 _tokenId) public {
        require(supportedNFTs[_nftAddress], "NFT not supported");

        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == msg.sender, "Caller is not the owner of this NFT");
        require(nft.getApproved(_tokenId) == address(this), "Contract is not approved to transfer this NFT");

        Offer storage offer = swapOffers[_swapOfferId];
        nft.transferFrom(msg.sender, offer.offeror, _tokenId);
        IERC721(offer.nftAddress).transferFrom(offer.offeror, msg.sender, offer.tokenId);

        emit SwapOfferExecuted(_swapOfferId, msg.sender, offer.nftAddress, offer.tokenId);
        delete swapOffers[_swapOfferId];
    }

    /**
     * @dev Swap tokens of the ERC20 pool.
     * @param _tokenAddress The address of the token to be swapped.
     * @param amount0Out The amount of the first token.
     * @param amount1Out The amount of the second token.
     * @param to The address of the recipient.
     */
    function swap(address _tokenAddress, uint amount0Out, uint amount1Out, address to) public {
        ERC20Pool storage pool = erc20Pools[_tokenAddress];
        require(amount0Out > 0 || amount1Out > 0, 'INSUFFICIENT_OUTPUT_AMOUNT');
        require(amount0Out < pool.reserve0 && amount1Out < pool.reserve1, 'INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        {
            balance0 = pool.token0.balanceOf(address(this));
            balance1 = pool.token1.balanceOf(address(this));
            uint amount0In = balance0 - pool.reserve0 + amount0Out;
            uint amount1In = balance1 - pool.reserve1 + amount1Out;

            require(balance0 - amount0Out == balance1 * pool.reserve0 / pool.reserve1, 'INVALID_SWAP');
            require(balance1 - amount1Out == balance0 * pool.reserve1 / pool.reserve0, 'INVALID_SWAP');
        }

        _update(_tokenAddress, balance0, balance1);
        _safeTransfer(pool.token0, to, amount0Out);
        _safeTransfer(pool.token1, to, amount1Out);
    }

    /**
     * @dev Update the reserves of the ERC20 pool.
     * @param _tokenAddress The address of the token.
     * @param balance0 The balance of the first token.
     * @param balance1 The balance of the second token.
     */
    function _update(address _tokenAddress, uint balance0, uint balance1) internal {
        ERC20Pool storage pool = erc20Pools[_tokenAddress];
        pool.reserve0 = balance0;
        pool.reserve1 = balance1;
    }

    /**
     * @dev Safely transfer ERC20 tokens.
     * @param token The token to be transferred.
     * @param to The address of the recipient.
     * @param value The amount of tokens to be transferred.
     */
    function _safeTransfer(IERC20 token, address to, uint value) private {
        bool sent = token.transfer(to, value);
        require(sent, "Token transfer failed");
    }
}
