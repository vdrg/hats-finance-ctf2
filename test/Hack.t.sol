// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Hack.sol";

contract CounterTest is Test {
    Vault public vault;
    Hack public hack;

    function setUp() public {
        // Use any address as vault owner
        address vaultOwner = address(1);
        hoax(vaultOwner);
        vault = new Vault{value:1 ether}();


        hack = new Hack(vault);
    }

    function testHack() public {
        assertEq(address(vault).balance, 1 ether);

        // use a different address for the hack
        address hacker = address(2);
        // get some funds and set the msg.sender as the hacker
        hoax(hacker);

        uint256 deposit = 1 ether;
        uint256 extra = 1 ether;
        hack.hack{ value: deposit + extra }(deposit, extra);

        // Check that the hacker is the holder
        assertEq(vault.flagHolder(), hacker);
    }
}
