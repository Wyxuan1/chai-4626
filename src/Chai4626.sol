// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
//import erc4626
import {ERC20} from "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol";
import {ERC4626} from "https://github.com/transmissions11/solmate/blob/main/src/mixins/ERC4626.sol";
import {Chai} from "./Chai.sol";

interface PotLike {
    function chi() external returns (uint256);
}

contract Chai4626 is ERC4626 {
    Chai public chaiContract;
    ERC20 public daiToken;
    PotLike public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    uint256 public ibalance;

    // Chai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    constructor(
        address _dai,
        address _chai
    ) ERC4626(ERC20(_dai), "wCHAI", "Wrapped 4626 Chai") {
        daiToken = ERC20(_dai);
        daiToken.approve(_chai, 2 ** 256 - 1);
        chaiContract = Chai(_chai);
    }

    function _mint(address receiver, uint256 amount) internal override {
        // Amount of "shares" in chai. probably more gas efficient to import
        chaiContract.join(address(this), amount);
        _shares = div(amount, pot.chi());
        totalSupply += _shares;
        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[receiver] += _shares;
        }

        emit Transfer(address(0), receiver, _shares);
    }

    function _burn(address owner, uint256 shares) internal override {
        chaiContract.exit(address(this), shares);
        daiToken.transfer(owner, shares);
        balanceOf[owner] -= shares;
        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= shares;
        }
        emit Transfer(owner, address(0), shares);
    }

    function totalAssets() public view override returns (uint256) {
        return mul(totalAssets, pot.chi());
    }
}
