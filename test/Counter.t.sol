// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Chai4626.sol";
import "./DummyERC20.sol";

contract Chai4626Test is Test {
    Counter public counter;

    function setUp() public {
        address public chai = deployCode("./abi/Chai.abi.json");
        tokenDAI = new DummyERC20("DAI", "DAI", 18, 1000);
        chai4626 = new Chai(chai, address(tokenDAI));
    }

    
}
