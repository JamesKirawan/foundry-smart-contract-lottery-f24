// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;
import {Test, console2} from "forge-std/Test.sol";
import {CreateSubscription} from "script/Interactions.s.sol";
import {FundSubscription} from "script/Interactions.s.sol";
import {AddConsumer} from "script/Interactions.s.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Raffle} from "script/DeployRaffle.s.sol";

contract InteractionTest is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane;
    uint32 callbackGasLimit;
    uint256 subscriptionId;
    address link;
    address account;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane = config.gasLane;
        callbackGasLimit = config.callbackGasLimit;
        subscriptionId = config.subscriptionId;
        account = config.account;
        link = config.link;
    }

    /*//////////////////////////////////////////////////////////////
                          CREATE SUBSCRIPTION
    //////////////////////////////////////////////////////////////*/
    function testCreateSubscription() public {
        // Arrange
        CreateSubscription createSubscription = new CreateSubscription();

        // Act / Assert
        (subscriptionId, ) = createSubscription.createSubscriptionUsingConfig();
    }

    /*//////////////////////////////////////////////////////////////
                            FUNDSUBSCRIPTION
    //////////////////////////////////////////////////////////////*/
    function testFundSubscription() public {
        // Arrange
        FundSubscription fundSubscription = new FundSubscription();
        CreateSubscription createSubscription = new CreateSubscription();
        (subscriptionId, vrfCoordinator) = createSubscription
            .createSubscriptionUsingConfig();

        // Act / Assert
        fundSubscription.fundSubscriptionUsingConfig(
            vrfCoordinator,
            subscriptionId
        );
    }

    /*//////////////////////////////////////////////////////////////
                              ADDCONSUMER
    //////////////////////////////////////////////////////////////*/
    function testAddConsumer() public {
        // Arrange
        AddConsumer addConsumer = new AddConsumer();
        CreateSubscription createSubscription = new CreateSubscription();
        (subscriptionId, vrfCoordinator) = createSubscription
            .createSubscriptionUsingConfig();

        // Act / Assert
        addConsumer.addConsumerUsingConfig(
            address(raffle),
            vrfCoordinator,
            subscriptionId,
            account
        );
    }
}
