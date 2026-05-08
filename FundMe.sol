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

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    // Enable all uint256 values (like 'msg.value') to use functions from the PriceConverter library.
    using PriceConverter for uint256;

    // Example state variable
    uint256 public myValue = 1;

    // NOTE:
    // This value is currently compared directly against msg.value (Wei),
    // not actual USD. A price feed would be needed for real USD conversion.
    // We updated the number so that it doesn't be just 5 since getConversionRate return a number
    // with an 18 decimal. We can just declare it as '5 * 1e18' or '5 * (10**18)'
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

        // Here, msg.value is automatically passed as the first argument
        // to getConversionRate() through the PriceConverter library.        
        /* msg.value.getConversionRate();*/
        
        // Convert sent ETH into USD value and verify minimum amount.
        // msg.value = amount of ETH sent in Wei since 1 ETH = 1e18 Wei
        require(msg.value.getConversionRate() >= minimumUSD, "ETH amount is below the minimum requirement."); // 1e18 = 1 ETH = 1,000,000,000,000,000,000 Wei = 1 * 10^18 Wei
        
        // Store funder address
        funders.push(msg.sender);

        // Update amount funded by this sender
        addressToAmountFunded[msg.sender] += msg.value;

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


        // Withdraws all funded amounts by resetting each funder's balance.
        // Iterates through the funders array and sets every funded amount to 0.    
        function withdraw() public {

        // Loop through all funders
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {

            // Get funder address at current index
            address funder = funders[funderIndex];

            // Reset funded amount for this address
            addressToAmountFunded[funder] = 0;
        }
    }

    
}