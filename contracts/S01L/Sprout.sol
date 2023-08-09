// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/ISprout.sol";
import "./S01L.sol";
import "./S33D2.sol";

/**
 * @title Sprout contract
 * @dev Implements the operations of the Sprout tokens
 */
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
    S01L private _s01l;
    S33D2 private _s33d2;

    // Track the current generation
    uint256 public currentGeneration = 0;

    // Mapping of generations to array of seeds
    mapping(uint256 => string[]) public generationSeeds;

    // Mapping of seeds to their generation
    mapping(string => uint256) public seedGenerations;

    /**
     * @dev Contract constructor
     */
    constructor() ERC721("Sprout", "SPT") {}

    /**
     * @dev Initialize sprout with given parameters
     * @param owner address of the owner
     * @param _plantType plant type of the sprout
     * @param _flowerCount count of flowers for the sprout
     * @param _genus genus of the sprout
     * @param _species species of the sprout
     * @param _variety variety of the sprout
     */
    function initialize(
        address owner,
        uint256 _plantType,
        uint256 _flowerCount,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) external onlyOwner {
        transferOwnership(owner);
        plantType = _plantType;
        flowerCount = _flowerCount;
        genus = _genus;
        species = _species;
        variety = _variety;
        cloningPeriodStart = block.timestamp + 2 weeks;
    }

    /**
     * @dev Set the flowering status of the sprout
     * @param _isFlowering flowering status to set
     */
    function setIsFlowering(bool _isFlowering) external onlyOwner {
        isFlowering = _isFlowering;
    }

    /**
     * @dev Set the pollination status of the sprout
     * @param _isPollinated pollination status to set
     */
    function setIsPollinated(bool _isPollinated) external onlyOwner {
        isPollinated = _isPollinated;
    }

    /**
     * @dev Set the harvested status of the sprout
     * @param _isHarvested harvested status to set
     */
    function setIsHarvested(bool _isHarvested) external onlyOwner {
        isHarvested = _isHarvested;
    }

    /**
     * @dev Start the flowering process of the sprout
     * @param _pollinationPeriod pollination period for the sprout
     */
    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");
        isFlowering = true;
        pollinationPeriod = block.timestamp + _pollinationPeriod;
    }

    /**
     * @dev Pollinate the sprout
     * @param pollen address of the pollen used for pollination
     */
    function pollinate(address pollen) external onlyOwner {
        require(isFlowering && !isPollinated && block.timestamp <= pollinationPeriod, "Cannot pollinate at this time");
        pollenAddress = pollen;
        isPollinated = true;
        pollinationCount++;
    }

    function cloneSprout(address newOwner, S01L _s01lContract) external onlyOwner returns (address) {
        require(!isFlowering && block.timestamp >= cloningPeriodStart, "Cannot clone at this time");
        
        address clonedSproutAddress = _s01lContract.cutClone(
            newOwner, 
            plantType, 
            flowerCount, 
            genus, 
            species, 
            variety
        );
    
        require(clonedSproutAddress != address(0), "Cloning failed");
        return clonedSproutAddress;
    }

    /**
     * @dev Harvest the sprout and create S33D2 tokens
     */
         function harvest() external onlyOwner {
        require(isPollinated && !isHarvested, "Cannot harvest at this time");
        isHarvested = true;
        _s01l.S0WS33D2(owner());
        currentGeneration++;
    }
}

