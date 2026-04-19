pragma solidity ^0.5.3; // Sets the compiler to use Solidity version 0.5.3 or compatible versions below 0.6.0.

/*
Examples:
1. Restricting write access (bascic syntax)
2. Valoidate inputs (inputs, why useful?)
3. Reentrancy guard (reentrancy hack)
*/

contract FuncModifier {

    // We will use these variables to demonstrate how to use modifiers.
    
    // Declares a state variable owner of type address.
    // It stores the address of the contract owner on the blockchain.
    address public owner; // public creates a getter function.
    uint public x = 10;
    bool locked; // This declares a boolean variable used to track whether a function is 
    // currently executing (for reentrancy protection).

    constructor() public {
        // Set the transaction (deployer of the contract) sender as the owner of the contract.
        owner = msg.sender;
    }

    // Important: The _; in a modifier is required because it tells Solidity where the actual function code should run.
    // If you forget it, the function will not execute correctly.

    // The function code runs where _; is placed inside the modifier (usually after the checks, but can be before or after depending on placement).
    // In the case below, the function will run the modifier code, and then will run the code within the function.

    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        // Checks that the caller is the owner. If not, the transaction reverts with an error message.
        require(msg.sender == owner, "Not Owner");
        _; // This represents where the actual function (changerOwner) code will execute.
    }

    // Modifiers can take inputs. This modifier checks that the
    // address passed in is not the zero address.
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not a Valid Address"); // Checks that the address is not the zero address.
        _; // Executes the rest of the function (changerOwner).
    }

    // Defines a function to change the contract owner. It uses two modifiers in order:
    // onlyOwner → only current owner can call
    // validAddress → new owner must not be zero address
    function changerOwner(address _newOwner) public onlyOwner validAddress (_newOwner){
        owner = _newOwner; // Updates the owner to the new address.
    }
    // Important: The fucntion will NOT run twice. It will take 1st modifier, then 2nd modifier
    // Then run the function code


    // Modifiers can be called before and / or after a function.
    // This modifier prevents a function from being called while it is still executing.
    modifier noReentrancy() { // Defines a modifier to prevent reentrancy attacks.
        require(!locked, "Locked"); // Checks that the contract is not already in a locked state.

        locked = true; // Locks the contract before executing the function.
        _; // Executes the function body.
        locked = false; // Unlocks the contract after execution.
    }

    function decrement(uint i) public  {
        x -= 1; // Decreases the value of x by 1.

        if (i > 1) {
            decrement(i - 1); // Recursively calls itself with i - 1.
            // This recursion can consume a lot of gas if i is large
        }
    }
}