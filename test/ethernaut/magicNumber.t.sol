//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Test.sol";
import "forge-std/console.sol";

/* 
- the chalenge is to create a contract that contain a function named : whatIsTheMeaningOfLife() that returns 42 num
- the trick here is to make it less or equal 10 bytes (10 opcodes) 
*/
/*
- first we gonna write the run time code :
push(0x2a) =>0x602a: pushing the value 42 to the top of the stack
push(0x00) => 6000 : this is the offset memory 
mstore;(0x52) => 52: here we store the value to the 0x00 memory place;
push(0x20) => 6020 : this is the lenth of the value stored in memory 
push(0x00) => 6000 : this is the pointer to the value in the memory 
return;(0xf3) =>f3 : this will return the value that from with length 0x20, and position 0x00 in memory 
=======> this will be our RUNTIME CODE <===========
  0x602a60005260206000f3 (which is 10 bytes)
*/
/*
 - second we gonna creat our creation code : 
 push10(602a60005260206000f3) : this will be padding with 22 zero || the push10 is 0x69 
 push1(0x00) => 6000
 mstore
 push (0a) => 600a : this is the lenght of the value wanna return (runtimecode) ;
 push1(0x16) =>6016   : this is the pointer to the memory (22 in hex)
 return;
  ==============> this will be the CREATION CODE <=================
  0x69602a60005260206000f3600052600a6016f3
  
*/
//now time to create our factory to deploy the bytecode
contract factory {
    function deployme() public returns (address) {
        bytes memory initcode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        assembly {
            // in the dynamic array the initcode variable is a refrence to an address of the bytecode in memory
            // the first 32 of the bytecode in memory is the lenght of it
            // mload(initcode) will read first 32bytes of the init code in memory which is the lenght of it
            //create takes 3 args(value of eth,the creationcode,length) and return an address
            addr := create(0, add(initcode, 0x20), mload(initcode))
        }
        return addr;
    }
}
