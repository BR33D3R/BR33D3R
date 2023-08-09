// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "./libraries/S01LLibrary.sol";

contract S33DFactory {
    S01LLibrary.Data private s01lData;

    function _createAndWhitelistS33D(address s33dAddress) internal returns (address) {
        isWhitelisted[s33dAddress] = true;
        s01lData.addS33DContract(s33dAddress);
        return s33dAddress;
    }

    function S0WS33D() public onlyOwner returns (address) {
        S33D newS33D = new S33D(this);
        return _createAndWhitelistS33D(address(newS33D));
    }

    function S0WS33D2() public onlyOwner returns (address) {
        S33D2 newS33D2 = new S33D2();
        return _createAndWhitelistS33D(address(newS33D2));
    }
}
