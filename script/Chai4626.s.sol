// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Chai4626.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Chai4626 wchai = new Chai4626(
            ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F)
        );

        vm.stopBroadcast();
    }
}
