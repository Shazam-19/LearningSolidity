// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Delegatecall
- A low level funcion similar to call
- When contract A delegatecall contract B, 
it runs B's code inside A's context (storage, msg.sender, msg.value)
  - msg.sender - Refer to the caller who called contract A
  - msg.value - Refer to the value that was sent to contract A
- Can upgrade contract A without changing any code inside it

Why is it useful?
Using 'delegatecall' we can write upgradable contracts.
*/

contract B {
    // State variables are in the EXACT same order as contract A
    uint256 public num;
    address public sender;
    uint public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

}

contract B2 {
    // State variables are in the EXACT same order as contract A
    uint256 public num;
    address public sender;
    uint public value;

    function setVars(uint256 _num) public payable {
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }

}

contract A {

    uint256 public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint256 _num) public payable {

        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

}