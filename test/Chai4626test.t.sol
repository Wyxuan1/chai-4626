// Tests for the Chai contract
pragma solidity ^0.8.13;

// import {console} from "forge-std/console.sol";
import "forge-std/Test.sol";
import {Chai4626} from "../src/Chai4626.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";

contract Test4626 is Test {
    using stdStorage for StdStorage;
    Chai4626 private chai;
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    // ty richard heart
    address public immutable DAIwhale =
        0x075e72a5eDf65F0A5f44699c7654C1a76941Ddc8;
    uint256 public mainnetFork;
    ERC20 public dai;

    function setUp() public {
        mainnetFork = vm.createFork("http://localhost:8545");
        vm.selectFork(mainnetFork);
        dai = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        vm.label(DAIwhale, "DAIwhale");
        chai = new Chai4626();
    }

    function testDepositAndWithdraw() public {
        vm.selectFork(mainnetFork);
        vm.prank(DAIwhale);
        dai.approve(address(chai), 100000);
        chai.deposit(100, DAIwhale);

        chai.withdraw(100, msg.sender, msg.sender);
        vm.stopPrank();
        assertEq(chai.balanceOf(DAIwhale), 0);
    }
}
