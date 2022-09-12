// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract User {
    uint public id = 0;

    struct userInfo {
        uint userId;
        address userAdd;
        string name;
        string contact;
        string blood_group;
        string gender;
        uint dob;
    }

    struct userAddress {
        uint userId;
        address userAddress1;
        bool valid;
    }

    event UserRegistered (address user);

    mapping (uint => userInfo) userList;
    mapping (address => userAddress) userAddressList;
    uint[] public userIdList;

    modifier userExist() {
        address userAdd = msg.sender;
        require(!userAddressList[userAdd].valid, "User Already Exists!");
       _;
   }

    function Register(string memory _name, string memory _contact, string memory _blood_group, string memory _gender, uint _dob) userExist public {
        userList[id] = userInfo(id, msg.sender, _name, _contact, _blood_group, _gender, _dob);
        userAddressList[msg.sender] = userAddress(id, msg.sender, true);
        userIdList.push(id);
        id++;
        emit UserRegistered(msg.sender);
    }

    function getUsers() view public returns(uint[] memory) {
        return userIdList;
    }
    
    function getParticularUser(uint _userId) public view returns (string memory, string memory, string memory, string memory, address, bool, uint) {
        userInfo memory user = userList[_userId];
        userAddress memory userAdd = userAddressList[user.userAdd];
        
        return (user.name, user.contact, user.blood_group, user.gender, userAdd.userAddress1, userAdd.valid, user.dob);
    }

    function countUser() view public returns (uint) {
        return userIdList.length;
    }

    function isUserValid(address user) external view returns (bool) {
        if(userAddressList[user].valid == true) return true;
        else return false;
    }

}
