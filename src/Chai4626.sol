// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
//import erc4626
import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC4626} from "solmate/mixins/ERC4626.sol";
import {Chai} from "./Chai.sol";

contract Chai4626 is ERC4626 {
    Chai public chai;

    // Chai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    constructor(address _dai, address _chai) ERC4626("4626 Chai", "wCHAI", 18) {
        daiToken = ERC20(_dai);
        daiToken.approve(address(Chai), 2 ** 256 - 1);
        chai = Chai(_chai);
    }

    function _mint(address receiver, uint256 amount) internal override {
        Chai.join(address(this), assets);
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address owner, uint256 shares) internal override {
        Chai.exit(address(this), shares);
        daiToken.transfer(receiver, shares);
        balanceOf[from] -= amount;
        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }
        emit Transfer(from, address(0), amount);
    }

    function totalAssets() public view override returns (uint256) {
        return chai.dai(address(this));
    }
}
