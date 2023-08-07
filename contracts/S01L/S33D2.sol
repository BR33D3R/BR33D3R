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


contract S33D2 is ERC721, ERC721Burnable, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => S33DData) public s33dData;
    uint256 public flowerCount;
    uint256 public cost = 0 ether;
    S33D private _s33d;

    IGenusSpeciesVariety public genusSpeciesVarietyGenerator; // Add a state variable to hold the generator contract address

    constructor(uint256 _flowerCount, address _genusSpeciesVarietyGenerator) ERC721("S33D2", "S33D2") {
        flowerCount = _flowerCount;
        genusSpeciesVarietyGenerator = IGenusSpeciesVariety(_genusSpeciesVarietyGenerator); // Initialize the generator contract
        for (uint256 i = 0; i < flowerCount; i++) {
            _tokenIdCounter.increment();
            uint256 newTokenId = _tokenIdCounter.current();
            _mint(msg.sender, newTokenId);
        }
    }
   
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

    function mintForOwner(
        address to,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) external onlyOwner {
        _mint(to, _genus, _species, _variety);
    }
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

    function burn(uint256 tokenId) public override onlyOwner {
        _burn(tokenId);
    }

        function setCost(uint256 newCost) public onlyOwner {
        cost = newCost;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
