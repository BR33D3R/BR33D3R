pragma solidity ^0.8.20;

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
