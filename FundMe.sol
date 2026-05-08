// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
FundMe Contract
---------------
Purpose:
- Allow users to fund the contract with ETH
- Enforce a minimum funding amount in USD
- Track funders and their contributions
- Allow funds to be withdrawn later
*/

// Import Chainlink price feed interface
// Used to fetch the ETH/USD price on-chain
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    // Example state variable
    uint256 public myValue = 1;

    // NOTE:
    // This value is currently compared directly against msg.value (Wei),
    // not actual USD. A price feed would be needed for real USD conversion.
    // We updated the number so that it doesn't be just 5 since getConversionRate return a number
    // with an 18 decimal or we can just write it as '5 * 1e18' or '5 * (10**18)'
    uint256 public minimumUSD = 5 * 1e18; // Minimum amount required to fund the contract

    // Keep track of everyone's addresses who will send money to this contract
    address[] public funders;

    // Track how much ETH each address funded
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    
    // Allows users to fund the contract with ETH.
    // Requirements: Sent ETH must be worth at least minimumUSD.
    function fund() public payable {

        // Example state update
        // This change will revert if require() below fails
        myValue += 2;
        
        
        // Convert sent ETH into USD value and verify minimum amount.
        // msg.value = amount of ETH sent in Wei since 1 ETH = 1e18 Wei
        require(getConversionRate(msg.value) >= minimumUSD, "ETH amount is below the minimum requirement."); // 1e18 = 1 ETH = 1,000,000,000,000,000,000 Wei = 1 * 10^18 Wei
        
        // Store funder address
        funders.push(msg.sender);

        // Update amount funded by this sender
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

        /*
        What does revert do?

        If require() fails:
        - All state changes made in this transaction are undone
        - Remaining unused gas is refunded to the caller
        - Transaction execution stops immediately

        Example:
        - myValue += 2 will be reverted if require() fails
        */
    }


    // Placeholder function for withdrawing contract funds
    function withdraw() public {

    }

    
    // Returns the latest ETH/USD price from Chainlink.
    // Return value uses 18 decimals for consistency.
    function getPrice() public view returns (uint256) {
        // We want to contract another contract so what do we need?
        // Address - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI (provided through the imported interface)

        // Sepolia ETH / USD Address
        // Docs: https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = 
                AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // Since we don't need all these returned data below, we can just remove them and leave a ','
        // (uint80 roundID, int256 price, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();
        (, int256 price,,,) = priceFeed.latestRoundData();

        /*
        Chainlink ETH/USD price feed returns 8 decimals.

        Example:
        2000.00000000 = 200000000000

        Multiply by 1e10 to convert from 8 decimals to 18 decimals.
        */
        return uint256(price * 1e10);

        // Solidity does not support floating-point numbers, so decimal precision must be handled manually.

    }


    /*
    Converts an ETH amount into its USD value.

    Example:
        How much is 1 ETH?
        Answer: 2000_000000000000000
        (2000_000000000000000 * 1_000000000000000000) / 1e18;
        $2000 = 1 ETH
    */
    function getConversionRate(uint256 ethAmount) 
        public
        view
        returns (uint256) {

        // Fetch ETH price in USD (18 decimals)
        uint256 ethPrice = getPrice();

        // 1000000000000000000 * 1000000000000000000 = 1000000000000000000000000000000000000
        // 1000000000000000000000000000000000000 / 18 = 1000000000000000000
        // Always multiply before dividing to reduce precision loss.
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUSD;
    }
}