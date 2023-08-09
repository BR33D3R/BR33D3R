//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import "@openzeppelin/contracts/proxy/Clones.sol";
import "../interfaces/ISprout.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CloneFactory is Ownable{
    address public sproutImplementation;

    function setSproutImplementation(address _sproutImpl) external onlyOwner {
        sproutImplementation = _sproutImpl;
    }

    function cutClone(
        address newOwner, 
        uint256 plantType, 
        uint256 flowerCount, 
        string memory genus, 
        string memory species, 
        string memory variety
    ) external virtual returns (address) {
        require(msg.sender == address(sproutImplementation), "Only original Sprout can clone");
        address clonedSprout = Clones.clone(sproutImplementation);
        ISprout(clonedSprout).initialize(newOwner, plantType, flowerCount, genus, species, variety);
        return clonedSprout;
    }
}
