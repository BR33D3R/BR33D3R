// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./libraries/S01LLibrary.sol";
import "./interfaces/IS33D.sol";
import "./Sprout.sol";

/// @title S01L contract
/// @notice This contract handles interactions with S33D and Sprout contracts.
/// @dev The contract uses OpenZeppelin's Ownable for owner-only functions and S01LLibrary for data operations.
contract S01L is Ownable {
    using S01LLibrary for S01LLibrary.Data;

    /// @dev Storage for the contract data
    S01LLibrary.Data private s01lData;

    /// @notice Registers a new S33D contract.
    /// @dev This function can only be called by the owner.
    /// @param s33dContract The address of the S33D contract to register.
    /// @return The address of the registered S33D contract.
    function S0WS33D(address s33dContract) public onlyOwner returns (address) {
        s01lData.addS33DContract(s33dContract);
        return s33dContract;
    }

    /// @notice Registers a new S33D2 contract.
    /// @dev This function can only be called by the owner.
    /// @param s33dContract The address of the S33D2 contract to register.
    /// @return The address of the registered S33D2 contract.
    function S0WS33D2(address s33dContract) public onlyOwner returns (address) {
        s01lData.addS33DContract(s33dContract);
        return s33dContract;
    }

    /// @notice Plants a new Sprout contract.
    /// @dev This function can only be called by the owner.
    /// @return The address of the newly planted Sprout contract.
    function plantSprout() public onlyOwner returns (address) {
        Sprout newSprout = new Sprout();
        return s01lData.plantSprout(address(newSprout));
    }

    /// @notice Burns a token and plants a new Sprout contract.
    /// @dev This function requires the caller to be whitelisted and to own the token.
    /// @param tokenId The ID of the token to burn.
    function burnAndPlant(uint256 tokenId) public {
        require(s01lData.isWhitelisted(msg.sender), "Only whitelisted contracts can burn and plant");

        if (msg.sender == s01lData.getS33DContract(s01lData.getContractIdCounter()) || msg.sender == s01lData.getS33DContract(s01lData.getSproutIdCounter())) {
            IS33D s33dContract = IS33D(msg.sender);
            require(s33dContract.ownerOf(tokenId) == msg.sender, "Only owner can burn and plant");
            s33dContract.burn(tokenId); // Burn the NFT
        }

        plantSprout(); // Create a new sprout
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
