// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;
import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {ERC4626} from "solmate/src/mixins/ERC4626.sol";
import {Chai} from "./Chai.sol";

interface PotLike {
    function chi() external view returns (uint256);
}

/// @title 4626 Chai
/// @author William X
/// @notice This contract is a wrapper for Chai
contract Chai4626 is ERC4626 {
    Chai public constant CHAICONTRACT =
        Chai(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    ERC20 public constant DAITOKEN =
        ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    PotLike public immutable POT =
        PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);

    uint256 public assetBalance = 0;

    constructor() ERC4626(DAITOKEN, "wCHAI", "Wrapped 4626 Chai") {
        DAITOKEN.approve(address(CHAICONTRACT), 2 ** 256 - 1);
    }

    function _mint(address receiver, uint256 amount) internal override {
        // Amount of "shares" in chai. probably more gas efficient to import
        CHAICONTRACT.join(address(this), amount);
        uint256 _shares = amount / POT.chi();
        totalSupply += _shares;
        // mint the shares from erc20
        super._mint(receiver, _shares);
    }

    function _burn(address owner, uint256 shares) internal override {
        CHAICONTRACT.exit(address(this), shares);
        DAITOKEN.transfer(owner, shares);
        super._burn(owner, shares);
    }

    function totalAssets() public view override returns (uint256) {
        return assetBalance;
    }

    // Update share exchange rate and internal balance of chi
    function drip() public {
        assetBalance = CHAICONTRACT.dai(address(this));
    }

    function beforeWithdraw(uint256, uint256) internal override {
        drip();
    }

    function afterDeposit(uint256, uint256) internal override {
        drip();
    }
}
