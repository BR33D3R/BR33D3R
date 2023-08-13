// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/ISprout.sol";
import "./S01L.sol";
import "./S33D.sol";

/**
 * @title Sprout contract
 * @notice Implements the operations of the Sprout tokens.
 */
contract Sprout is ERC721, Ownable {
        using Counters for Counters.Counter;
        using SafeMath for uint256;
        using Strings for uint256;


    // Counter for unique token IDs
    Counters.Counter private _tokenIdCounter;

    enum PlantType { Flower, Pollen }
    PlantType public plantType;
    string private baseURI;

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
    S33D private _s33d;
    uint256 public mintPrice = 0.01 ether;

    // Track the current generation
    uint256 public currentGeneration = 0;

    // Mapping of generations to array of seeds
    mapping(uint256 => string[]) public generationSeeds;

    // Mapping of seeds to their generation
    mapping(string => uint256) public seedGenerations;

    // Mapping to store Sprout's S33D details
    mapping(uint256 => SeedDetails) public sproutSeedDetails;

    struct SeedDetails {
        string name;
        string symbol;
        uint256 generation;
        address owner;
    }

    event Initialized(
        address indexed owner,
        PlantType plantType,
        string genus,
        string species,
        string variety
    );

    event FloweringStatusChanged(bool status);
    event PollinationStatusChanged(bool status, address indexed pollenAddress);
    event HarvestedStatusChanged(bool status);

    event SeedHarvested(
        uint256 sproutId,
        string name,
        string symbol,
        uint256 generation,
        address owner
    );

    /**
     * @notice Contract constructor.
     */
    constructor() ERC721("Sprout", "SPT") {}

    /**
     * @notice Initialize sprout with given parameters.
     * @param owner Address of the owner.
     * @param _plantType Plant type of the sprout.
     * @param _flowerCount Count of flowers for the sprout.
     * @param _genus Genus of the sprout.
     * @param _species Species of the sprout.
     * @param _variety Variety of the sprout.
     */
    function initialize(
        address owner,
        PlantType _plantType,
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
        emit Initialized(owner, _plantType, _genus, _species, _variety);
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

        function mint(address recipient) external payable {
        require(msg.value == mintPrice, "Payment does not match mint price");
        
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        _safeMint(recipient, newTokenId);
    }

    /**
     * @notice Set the flowering status of the sprout.
     * @param _isFlowering Flowering status to set.
     */
    function setIsFlowering(bool _isFlowering) external onlyOwner {
        isFlowering = _isFlowering;
        emit FloweringStatusChanged(_isFlowering);
    }

    /**
     * @notice Set the pollination status of the sprout.
     * @param _isPollinated Pollination status to set.
     */
    function setIsPollinated(bool _isPollinated) external onlyOwner {
        isPollinated = _isPollinated;
        emit PollinationStatusChanged(_isPollinated, pollenAddress);
    }

    /**
     * @notice Set the harvested status of the sprout.
     * @param _isHarvested Harvested status to set.
     */
    function setIsHarvested(bool _isHarvested) external onlyOwner {
        isHarvested = _isHarvested;
        emit HarvestedStatusChanged(_isHarvested);
    }

    /**
     * @notice Start the flowering process of the sprout.
     * @param _pollinationPeriod Pollination period for the sprout.
     */
    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");
        isFlowering = true;
        pollinationPeriod = block.timestamp + _pollinationPeriod;
        emit FloweringStatusChanged(true);
    }

    
    /**
     * @notice Pollinate the sprout.
     * @param pollen Address of the pollen used for pollination.
     */
    function pollinate(address pollen) external onlyOwner {
        require(
            isFlowering &&
                !isPollinated &&
                block.timestamp <= pollinationPeriod,
            "Cannot pollinate at this time"
        );
        pollenAddress = pollen;
        isPollinated = true;
        pollinationCount++;
        emit PollinationStatusChanged(true, pollen);
    }

    /**
     * @notice Harvest the sprout and create S33D2 tokens.
     * @param seedName Name of the harvested S33D.
     * @param seedSymbol Symbol of the harvested S33D.
     */
    function harvest(
        string memory seedName,
        string memory seedSymbol
    ) external onlyOwner {
        require(isPollinated && !isHarvested, "Cannot harvest at this time");
        isHarvested = true;

        S01L s01l = S01L(owner());
        s01l.S0WS33D(seedName, seedSymbol);

        currentGeneration++;

        sproutSeedDetails[currentGeneration] = SeedDetails({
            name: seedName,
            symbol: seedSymbol,
            generation: currentGeneration,
            owner: msg.sender
        });

        emit SeedHarvested(
            currentGeneration,
            seedName,
            seedSymbol,
            currentGeneration,
            msg.sender
        );
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

    // Allows owner to withdraw accumulated funds from contract
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}