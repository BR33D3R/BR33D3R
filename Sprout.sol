// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "S33DSFactory.sol";

interface ISprout {
    function initialize(
        address owner,
        uint256 _type,
        uint256 _flowerCount,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) external;
    function cloneSprout(address newOwner) external returns (address);
}

interface ID1RT {
    function sproutImplementation() external view returns (address);
    function updateSproutImplementation(address newImplementation) external;
}

contract Sprout is ERC721, Ownable {
    uint256 public plantType; // 0 = flower, 1 = pollen
    string public genus;
    string public species;
    string public variety;
    uint256 public flowerCount;
    uint256 public seedCount;
    uint256 public pollinationCount;
    uint256 public pollinationPeriod;
    uint256 public cloningPeriodStart;
    address public pollenAddress;

    bool public isFlowering = false;
    bool public isPollinated = false;
    bool public isHarvested = false;

    address public parent;
    IS33DSFactory private _s33ds;

     constructor() ERC721("Sprout", "PLANT") {
    }


    function initialize(
        address owner,
        uint256 _plantType,
        uint256 _flowerCount,
        string memory _genus,
        string memory _species,
        string memory _variety,
        IS33DSFactory s33ds  // pass the IS33DSFactory instance here
    ) external onlyOwner {
        transferOwnership(owner);
        plantType = _plantType;
        flowerCount = _flowerCount;
        genus = _genus;
        species = _species;
        variety = _variety;
        cloningPeriodStart = block.timestamp + 2 weeks;
        _s33ds = s33ds;  // set _s33ds here instead of constructor
    }

    function setIsFlowering(bool _isFlowering) external onlyOwner {
        isFlowering = _isFlowering;
    }

    function setIsPollinated(bool _isPollinated) external onlyOwner {
        isPollinated = _isPollinated;
    }

    function setIsHarvested(bool _isHarvested) external onlyOwner {
        isHarvested = _isHarvested;
    }

    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");
        isFlowering = true;
        pollinationPeriod = block.timestamp + _pollinationPeriod;
    }

    function pollinate(address pollen) external onlyOwner {
        require(isFlowering && !isPollinated && block.timestamp <= pollinationPeriod, "Cannot pollinate at this time");
        
        // Use the pollen argument here
        pollenAddress = pollen;
        
        isPollinated = true;
        pollinationCount++;
    }

    function cloneSprout(address newOwner, address d1rtAddress) external onlyOwner returns (address) {
        require(!isFlowering && block.timestamp >= cloningPeriodStart, "Cannot clone at this time");

        address sproutAddress = Clones.clone(ID1RT(d1rtAddress).sproutImplementation());
        
        ISprout sprout = ISprout(sproutAddress);
        sprout.initialize(newOwner, plantType, flowerCount, genus, species, variety);

        // Update the sprout implementation on D1RT
        ID1RT(d1rtAddress).updateSproutImplementation(sproutAddress);

        return sproutAddress;
    }
    
    function harvest() external onlyOwner {
        require(isPollinated && !isHarvested && block.timestamp > pollinationPeriod, "Cannot harvest at this time");
        isHarvested = true;

        for (uint256 i = 0; i < flowerCount; i++) {
            // Mint a new S33D for each flower.
           _s33ds.createS33D(genus, species, variety);
        }
    }
}
