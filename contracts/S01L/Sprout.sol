// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/ISprout.sol";
import "./interfaces/ID1RT.sol";
import "./S01L.sol";
import "./S33D2.sol";

/// @title Sprout Contract
/// @notice This contract represents a unique plant that can be cloned, pollinated and harvested. 
/// @dev Contract is ownable, ensuring certain actions can only be performed by the plant owner.
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

    /// @notice Constructs an instance of the Sprout contract.
    /// @dev The initial state of the plant is not flowering, not pollinated, and not harvested.
    constructor() ERC721("Sprout", "SPT") {}

    /// @notice Initializes the plant with given parameters.
    /// @dev The function can only be called by the contract owner.
    /// @param owner The owner of the plant.
    /// @param _plantType The type of the plant (0 for flower, 1 for pollen).
    /// @param _flowerCount The number of flowers the plant will produce when it's harvested.
    /// @param _genus The genus of the plant.
    /// @param _species The species of the plant.
    /// @param _variety The variety of the plant.
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

    /// @notice Sets the flowering state of the plant.
    /// @dev The function can only be called by the plant owner.
    /// @param _isFlowering The new flowering state of the plant.
    function setIsFlowering(bool _isFlowering) external onlyOwner {
        isFlowering = _isFlowering;
    }

    /// @notice Sets the pollinated state of the plant.
    /// @dev The function can only be called by the plant owner.
    /// @param _isPollinated The new pollinated state of the plant.
    function setIsPollinated(bool _isPollinated) external onlyOwner {
        isPollinated = _isPollinated;
    }

    /// @notice Sets the harvested state of the plant.
    /// @dev The function can only be called by the plant owner.
    /// @param _isHarvested The new harvested state of the plant.
    function setIsHarvested(bool _isHarvested) external onlyOwner {
        isHarvested = _isHarvested;
    }

    /// @notice Starts the flowering process of the plant.
    /// @dev The function can only be called by the plant owner. The plant cannot already be flowering.
    /// @param _pollinationPeriod The length of the pollination period in seconds.
    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");
        isFlowering = true;
        pollinationPeriod = block.timestamp + _pollinationPeriod;
    }

    /// @notice Pollinates the plant.
    /// @dev The function can only be called by the plant owner. The plant must be flowering and not already pollinated, and it must be within the pollination period.
    /// @param pollen The address of the pollen to use.
    function pollinate(address pollen) external onlyOwner {
        require(isFlowering && !isPollinated && block.timestamp <= pollinationPeriod, "Cannot pollinate at this time");
        
        // Use the pollen argument here
        pollenAddress = pollen;
        
        isPollinated = true;
        pollinationCount++;
    }

    /// @notice Clones the plant and transfers ownership to a new owner.
    /// @dev The function can only be called by the plant owner. The plant cannot be flowering, and it must be after the cloning period start time.
    /// @param newOwner The owner of the new cloned plant.
    /// @param d1rtAddress The address of the D1RT contract.
    /// @return The address of the new cloned plant.
    function cloneSprout(address newOwner, address d1rtAddress) external onlyOwner returns (address) {
        require(!isFlowering && block.timestamp >= cloningPeriodStart, "Cannot clone at this time");

        address sproutAddress = Clones.clone(ID1RT(d1rtAddress).sproutImplementation());
        
        ISprout sprout = ISprout(sproutAddress);
        sprout.initialize(newOwner, plantType, flowerCount, genus, species, variety);

        // Update the sprout implementation on D1RT
        ID1RT(d1rtAddress).updateSproutImplementation(sproutAddress);

        return sproutAddress;
    }

    /// @notice Harvests the plant by minting seed tokens.
    /// @dev The function can only be called by the plant owner. The plant must be pollinated and not already harvested.
    function harvest() external onlyOwner {
        require(isPollinated && !isHarvested, "Cannot harvest at this time");
        isHarvested = true;

        for (uint256 i = 0; i < flowerCount; i++) {
            _s33d2.mintForOwner(owner(), genus, species, variety);
        }

        // increment the currentGeneration
        currentGeneration++;
    }
}
