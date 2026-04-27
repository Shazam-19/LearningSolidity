pragma solidity ^0.5.3; // This contract is meant to be compiled with version 0.5.3 or up to 0.6.0

contract SimpleStorage { // Declareing a smart contract
    string public text; // State variable of a type String which is stored permanently in the blockchain STORAGE 
    /* public:
       - Makes the variable accessible from outside the contract.
       - Automatically creates a getter function for it.
    */

    // Define a function named set.
    function set(string memory _text) public { // The function is public, so anyone can call it.
        /*
        It takes one input _text of type string.
        The keyword memory means this variable is temporary and only exists during the function execution.
        */
        text = _text;
        /* This assigns the value of _text (temporary memory variable) to text (permanent storage variable).
           So whatever is passed to the function gets saved on the blockchain permanently.*/ 
    }

    // Defines a function named get.
    function get() public view returns (string memory) { // The function is public, so anyone can call it.
    // The keyword view means this function does not modify the blockchain state (it only reads data).
    
        return text; // Return a string stored in memory.
    }
}