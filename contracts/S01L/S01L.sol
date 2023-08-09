// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./S33DFactory.sol";
import "./CloneFactory.sol";
import "../Libraries/S01LLibrary.sol";
import "../interfaces/IS33D.sol";
import "./Sprout.sol";


/// @title S01L contract
/// @notice This contract handles interactions with S33D and Sprout contracts.
/// @dev The contract uses OpenZeppelin's Ownable for owner-only functions and S01LLibrary for data operations.
contract S01L is Ownable, CloneFactory, S33DFactory {
    using S01LLibrary for S01LLibrary.Data;

    /// @dev Storage for the contract data
    S01LLibrary.Data private s01lData;

    // Mapping to store the addresses of S33D contracts
    mapping(uint256 => address) public s33dContracts;

    // Mapping to store the addresses of Sprout contracts
    mapping(uint256 => address) public sproutContracts;

    constructor() S33DFactory(S01L(address(this))) {
 
    }


    /// @notice Plants a new Sprout contract.
    /// @dev This function can only be called by the owner.
    /// @return The address of the newly planted Sprout contract.
    function plantSprout() public onlyOwner returns (address) {
        Sprout newSprout = new Sprout();
        return s01lData.plantSprout(address(newSprout));
    }

    function cutClone(
        address newOwner, 
        uint256 plantType, 
        uint256 flowerCount, 
        string memory genus, 
        string memory species, 
        string memory variety
    ) external virtual override returns (address) {
        require(msg.sender == address(sproutImplementation), "Only original Sprout can clone");

        address clonedSprout = Clones.clone(sproutImplementation);
        ISprout(clonedSprout).initialize(newOwner, plantType, flowerCount, genus, species, variety);
        
        return clonedSprout;
    }

    /// @notice Burns a token and plants a new Sprout contract.
    /// @dev This function requires the caller to be whitelisted and to own the token.
    /// @param tokenId The ID of the token to burn.
    function burnAndPlant(uint256 tokenId) public {
        require(s01lData.isWhitelisted(msg.sender), "Only whitelisted contracts can burn and plant");

        // Get the relevant contract address
        address relevantS33DContract;
        if (msg.sender == s01lData.getS33DContract(s01lData.getContractIdCounter())) {
            relevantS33DContract = s01lData.getS33DContract(s01lData.getContractIdCounter());
        } else if (msg.sender == s01lData.getS33DContract(s01lData.getSproutIdCounter())) {
            relevantS33DContract = s01lData.getS33DContract(s01lData.getSproutIdCounter());
        } else {
            revert("Invalid sender");
        }

        IS33D s33dContract = IS33D(relevantS33DContract);
        require(s33dContract.ownerOf(tokenId) == msg.sender, "Only owner can burn and plant");

        // Burn the NFT
        s33dContract.burn(tokenId);

        // Create a new sprout
        plantSprout();
    }

    /// @notice Retrieves the address of a S33D contract by ID.
    /// @param contractId The ID of the S33D contract to retrieve.
    /// @return The address of the S33D contract.
    function getS33DContract(uint256 contractId) public view returns (address) {
        return s01lData.getS33DContract(contractId);
    }

    /// @notice Retrieves the address of a Sprout contract by ID.
    /// @param contractId The ID of the Sprout contract to retrieve.
    /// @return The address of the Sprout contract.
    function getSproutContract(uint256 contractId) public view returns (address) {
        return s01lData.getSproutContract(contractId);
    }
}
