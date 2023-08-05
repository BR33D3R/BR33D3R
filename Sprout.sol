pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IS33DS is IERC721 {
    function mint(address to) external;
}

contract Sprout is ERC721, Ownable {
    uint256 public type; // 0 = flower, 1 = pollen
    string public genus;
    string public species;
    string public variety;
    uint256 public flowerCount;
    uint256 public seedCount;
    uint256 public pollinationCount;
    uint256 public pollinationPeriod;
    uint256 public cloningPeriodStart;

    bool public isFlowering = false;
    bool public isPollinated = false;
    bool public isHarvested = false;

    address public parent;

    IS33DS private _s33ds;

    constructor(IS33DS s33ds) ERC721("Sprout", "SPT") {
        _s33ds = s33ds;
    }

    function initialize(
        address owner,
        uint256 _type,
        uint256 _flowerCount,
        string memory _genus,
        string memory _species,
        string memory _variety
    ) external onlyOwner {
        transferOwnership(owner);
        type = _type;
        flowerCount = _flowerCount;
        genus = _genus;
        species = _species;
        variety = _variety;
        cloningPeriodStart = block.timestamp + 2 weeks;
    }

    function startFlowering(uint256 _pollinationPeriod) external onlyOwner {
        require(!isFlowering, "Already flowering");
        isFlowering = true;
        pollinationPeriod = block.timestamp + _pollinationPeriod;
    }

    function pollinate(address pollen) external onlyOwner {
        require(isFlowering && !isPollinated && block.timestamp <= pollinationPeriod, "Cannot pollinate at this time");
        isPollinated = true;
        pollinationCount++;
    }

    function cloneSprout(address newOwner) external onlyOwner returns (address) {
        require(!isFlowering && block.timestamp >= cloningPeriodStart, "Cannot clone at this time");
        // implement logic to clone sprout
    }

    function harvest() external onlyOwner {
        require(isPollinated && !isHarvested && block.timestamp > pollinationPeriod, "Cannot harvest at this time");
        isHarvested = true;

        for (uint256 i = 0; i < flowerCount; i++) {
            _s33ds.mint(owner());
        }
    }
}

