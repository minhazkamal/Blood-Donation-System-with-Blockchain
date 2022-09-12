// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface UserQuery {
    function isUserValid(address user) external view returns (bool);
}

contract Request {
    uint public reqid = 0;
    address USER_CONTRACT_ADDRESS = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    // User user = User();

    struct RequestFormat {
        uint requestId;
        address requesterAdd;
        string pt_name;
        string pt_contact;
        string pt_blood_group;
        string pt_gender;
        string location;
        string info;
        bool isCompleted;
    }

    event PostRequest (address RequestPostedBy);
    event RespondRequest (address Responder, uint request_id, address RequestPostedBy);

    mapping (uint => RequestFormat) requestList;
    uint[] public requestIdList;
    mapping (address => uint) responderList;

    modifier userValid() {
        address userAdd = msg.sender;
        require(UserQuery(USER_CONTRACT_ADDRESS).isUserValid(userAdd), "User is not valid");
       _;
   }

   function postRequest(string memory _pt_name, string memory _pt_contact, string memory _pt_blood_group, string memory _pt_gender, string memory _location, string memory _info) userValid public {
        requestList[reqid] = RequestFormat(reqid, msg.sender, _pt_name, _pt_contact, _pt_blood_group, _pt_gender, _location, _info, false);
        requestIdList.push(reqid);
        reqid++;
        emit PostRequest(msg.sender);
   }

   function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

   function searchRequestById(uint _id) userValid public view returns(RequestFormat memory) {
       RequestFormat memory searchResult;
       searchResult = requestList[_id];
       return searchResult;
   }

   function searchRequesterAddressById(uint _id) userValid public view returns(address) {
       RequestFormat memory searchResult;
       searchResult = requestList[_id];
       return searchResult.requesterAdd;
   }

   function updateIsCompleted(uint _requestId) userValid public {
       require(msg.sender == requestList[_requestId].requesterAdd, "You don't have the permission");
       requestList[_requestId].isCompleted = true;
   }

   function respondToARequest(uint request_id) userValid public {
        require(msg.sender != searchRequesterAddressById(request_id), "Requester can not respond to his own request");
        responderList[msg.sender] = request_id;
        emit RespondRequest(msg.sender, request_id, searchRequestById(request_id).requesterAdd);
   }

}
