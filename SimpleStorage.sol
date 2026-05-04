// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
Basic Types & Storage Example

Demonstrates:
- Common Solidity data types
- State variables
- Default values
- Reading and writing state
*/

contract SimpleStorage {

    // Boolean (true/false)
    bool hasFavNum = true;

    // Unsigned integer (default visibility is internal)
    // `uint` is an alias for `uint256`
    uint256 public favNum = 88;

    // String (UTF-8 encoded text)
    string favNumInTxt = "eighty-eight";

    // Signed integer (can be negative)
    int256 favNegNum = -88;

    // Ethereum address (20 bytes)
    address myAddress = 0xF54EA090D66Ac6903cAE152d7E35EA0Ff59b42cc;

    // Fixed-size byte array (32 bytes)
    // "cat" is stored as bytes and padded with zeros
    bytes32 favBytes32 = "cat"; // 0x6361740000000000000000000000000000000000000000000000000000000000

    // Static Array
    uint256[3] listOfFavNums;

    struct Person {
        uint256 personFavNum;
        string name;
    }

    Person public myFriend = Person({personFavNum: 7, name: "Mai"});

    // Dynamic Array
    Person[] public listOfPeople; // []

    // Update the stored favorite number
    function store(uint256 _favNum) public {

        // Assign new value to state variable
        favNum = _favNum;
    }

    /*
    Read-only function (view):
    - Does NOT modify state
    - Free when called externally (no transaction gas cost)
    - Costs gas only when called internally by another function that modifies the state
    */
    function retrieve() public view returns (uint256) {

        return favNum;
    }

    function addPerson(string memory _name, uint256 _favNum) public {
        // Solidity will execute the line from inwards to outwerwards
        listOfPeople.push(Person({personFavNum: _favNum, name: _name}));
    }
}