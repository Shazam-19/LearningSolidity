// What is the purpose of this contract?
// - Allow users to fund the contract with ETH
// - Allow funds to be withdrawn later
// - Enforce a minimum funding amount

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FundMe {

    // Example state variable
    uint256 public myValue = 1;

    // Minimum amount required to fund the contract
    // NOTE:
    // This value is currently compared directly against msg.value (Wei),
    // not actual USD. A price feed would be needed for real USD conversion.
    uint256 public minimumUSD = 5;

    function fund() public payable {
        // Allow users to send $
        // Have a mnimum $ sent $5
        // 1. How do we send ETH to this contract?
        myValue += 2; // This will revert if the require below doesn't run
        
        // Require the user to send at least the minimum amount
        require(msg.value >= minimumUSD, "ETH amount is below the minimum requirement."); // 1e18 = 1 ETH = 1,000,000,000,000,000,000 Wei = 1 * 10^18 Wei

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

    function withdraw() public {

    }
}