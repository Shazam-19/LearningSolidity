// What we want to do in this contract?
// - Get funds from users
// - Withdraw funcds
// - Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FundMe {

    uint256 public myValue = 1;

    function fund() public payable {
        // Allow users to send $
        // Have a mnimum $ sent
        // 1. How do we send ETH to this contract?
        myValue += 2; // This will revert if the require below doesn't run
        require(msg.value > 1e18, "ETH Value must be 1 or more."); // 1e18 = 1 ETH = 1,000,000,000,000,000,000 Wei = 1 * 10^18 Wei

        // What is a revert?
        // Undo any actions that have been done, and send the remaining gas back

    
    }

    function withdraw() public {

    }
}