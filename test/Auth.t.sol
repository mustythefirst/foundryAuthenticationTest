// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../lib/forge-std/src/Test.sol";
import {Wallet} from "../src/Wallet.sol";

// forge test --match-path test/Auth.t.sol -vvvv

contract AuthTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    // The above function, everytime a new test is set up
    // a new instance of the Wallet contract is instantiates. 
    // This means after every function test it restarts and sets up a new
    // test

    function testSetOwner() public {
        wallet.setOwner(address(1));
        assertEq(wallet.owner(), address(1));
    }

    //The above function is testing for this function from Wallet.sol

    /* 
    function setOwner(address _owner) external {
        require(msg.sender == owner, "caller is not owner");
        owner = payable(_owner);
    } 
    */

    // if the owner is set to address one. The assertEq will verify
    // that wallet.owner which is now address 1, is indeed equal to
    // address 1. 

    function testFailNotOwner() public {
        // next call will be called by address(1)
        vm.prank(address(1));
        wallet.setOwner(address(this));
    }

    // The above function is testing for this function

     /* 
    function setOwner(address _owner) external {
        require(msg.sender == owner, "caller is not owner");
        owner = payable(_owner);
    } 
    */

    // In vm.prank setting anything other than adress(this).
    // will log a Test pass. If vm.prank(address(this)) is set
    // It will log a fail since the prank address is now the owner
    // The test is making sure that it fails. If it fails as not 
    // the address owner, then it will log test pass
    // if it does not fail and prank does own the contract
    // it will log fail



    // prank is cheatcode used in Foundry. vm.prank changes
    // the address identity to 1. 

    function testFailSetOwnerAgain() public {
        // msg.sender = address(this)
        wallet.setOwner(address(1));

        // Set all subsequent msg.sender to address(1)
        vm.startPrank(address(1));

        // all calls made from address(1)
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));
        wallet.setOwner(address(1));

        // Reset all subsequent msg.sender to address(this)
        vm.stopPrank();

        console.log("owner", wallet.owner());

        // call made from address(this) - this will fail
        wallet.setOwner(address(1));

        console.log("owner", wallet.owner());
    }

    // The above function is showing how multiple calls can be made instantly
    // using vm.startPrank and vm.stopPrank
}