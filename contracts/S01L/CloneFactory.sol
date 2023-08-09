SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./interfaces/ISprout.sol";

contract CloneFactory {
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
    ) external returns (address) {
        require(msg.sender == address(sproutImplementation), "Only original Sprout can clone");
        address clonedSprout = Clones.clone(sproutImplementation);
        ISprout(clonedSprout).initialize(newOwner, plantType, flowerCount, genus, species, variety);
        return clonedSprout;
    }
}
