// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "S33DSFactory.sol";

/**
 * @title ISprout
 * @dev This interface allows to initialize and clone a new Sprout.
 */
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

/**
 * @title ID1RT
 * @dev This interface allows to update and get the Sprout implementation.
 */
interface ID1RT {
    function sproutImplementation() external view returns (address);
    function updateSproutImplementation(address newImplementation) external;
}

/**
 * @title Sprout
 * @dev This contract represents a sprout, which includes various details of the plant. Inherits from ERC721 and Ownable.
 */
contract Sprout is ERC721, Ownable {
    // Variables that store information about the plant's type, genus, species, variety, and other related data.
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

    // Boolean variables indicating the current state of the sprout (whether it's flowering, pollinated, or harvested).
    bool public isFlowering = false;
    bool public isPollinated = false;
    bool public isHarvested = false;

    // Address of the parent sprout.
    address public parent;

    // Instance of the S33DSFactory contract.
    IS33DSFactory private _s33ds;

    // Constructor that sets the token's name and symbol.
    constructor() ERC721("Sprout", "PLANT") {}

    /**
     * @dev Initializes the Sprout with plant details and ownership. Can only be called by the owner.
     */
    function initialize(
        address owner,
        uint256 _plantType,
        uint256 _flowerCount,
        string memory _genus,
        string memory _species,
        string memory _variety,
        IS33DSFactory s33ds  // pass the IS33DSFactory instance here
    ) external onlyOwner {
        // Transfers the ownership to the provided address.
        transferOwnership(owner);

        // Assigns the plant details.
        plantType = _plantType;
        flowerCount = _flowerCount;
        genus = _genus;
        species = _species;
        variety = _variety;

        // Sets the cloning period start time.
        cloningPeriodStart = block.timestamp + 2 weeks;

        // Sets the S33DSFactory contract instance.
        _s33ds = s33ds;  // set _s33ds here instead of constructor
    }

    /**
     * @dev Sets the isFlowering state. Can only be called by the owner.
     */
    function setIsFlowering(bool _isFlowering) external onlyOwner {
        isFlowering = _isFlowering;
    }

    /**
     * @dev Sets the isPollinated state. Can only be called by the owner.
     */
    function setIsPollinated(bool _isPollinated) external onlyOwner {
        isPollinated = _isPollinated;
    }

    /**
     * @dev Sets the isHarvested state. Can only be called by the owner.
     */
    function setIsHarvested(bool _isHarvested) external onlyOwner {
        isHarvested = _isHarvested;
    }

    /**
     * @dev Starts the flowering of the plant. Can only be called by the owner.
     */
    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");

        // Sets the plant's state to flowering.
        isFlowering = true;

        // Sets the pollination period.
        pollinationPeriod = block.timestamp + _pollinationPeriod;
    }

    /**
     * @dev Pollinates the plant. Can only be called by the owner.
     */
    function pollinate(address pollen) external onlyOwner {
        require(isFlowering && !isPollinated && block.timestamp <= pollinationPeriod, "Cannot pollinate at this time");
        
        // Assigns the pollen address.
        pollenAddress = pollen;
        
        // Sets the plant's state to pollinated.
        isPollinated = true;

        // Increments the pollination count.
        pollinationCount++;
    }

    /**
     * @dev Clones a sprout and returns the new sprout's address. Can only be called by the owner.
     */
    function cloneSprout(address newOwner, address d1rtAddress) external onlyOwner returns (address) {
        require(!isFlowering && block.timestamp >= cloningPeriodStart, "Cannot clone at this time");

        // Creates a new sprout using the implementation from the D1RT contract.
        address sproutAddress = Clones.clone(ID1RT(d1rtAddress).sproutImplementation());
        
        // Initializes the new sprout.
        ISprout sprout = ISprout(sproutAddress);
        sprout.initialize(newOwner, plantType, flowerCount, genus, species, variety);

        // Updates the sprout implementation on the D1RT contract.
        ID1RT(d1rtAddress).updateSproutImplementation(sproutAddress);

        // Returns the new sprout's address.
        return sproutAddress;
    }
    
    /**
     * @dev Harvests the plant and mints new S33D tokens. Can only be called by the owner.
     */
    function harvest() external onlyOwner {
        require(isPollinated && !isHarvested && block.timestamp > pollinationPeriod, "Cannot harvest at this time");

        // Sets the plant's state to harvested.
        isHarvested = true;

        // For each flower, creates a new S33D token.
        for (uint256 i = 0; i < flowerCount; i++) {
           _s33ds.createS33D(genus, species, variety);
        }
    }
}
