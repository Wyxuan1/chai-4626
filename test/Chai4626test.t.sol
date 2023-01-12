// SPDX-License-Identifier: AGPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "erc4626-tests/ERC4626.test.sol";

import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {Chai4626} from "src/Chai4626.sol";

contract ERC4626StdTest is ERC4626Test {
    function setUp() public override {
        _underlying_ = address(new MockERC20("Mock DAI", "DAI", 18));
        _vault_ = address(new Chai4626(MockERC20(_underlying_)));
        _delta_ = 0;
        _vaultMayBeEmpty = true;
        _unlimitedAmount = false;
    }
}
