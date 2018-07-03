pragma solidity ^0.4.2;
import "./ContractBase.sol";

contract UsersPureData is ContractBase("v2") {
    address owner;
    address invoker;
    struct Users{
      bool active;
      address accountAddress;
      string publicKey;
      string idCartNo;
      string detail;
      uint time;
    }

    // userId(address) => Users 保存用户列表
    mapping(address=>Users) usersMap;
    // idCartNo => userId(address) 控制idCartNo唯一
    mapping(string=>address) addressMap;

    event onSetUsersPureDataInvokerAddress(address invokerAddress);

    function UsersPureData() public {
      owner = msg.sender;
      setInvoker(owner);
    }

    function setInvoker(address invokerAddress) public{
      if(msg.sender == owner){
        invoker = invokerAddress;
        onSetUsersPureDataInvokerAddress(invoker);
      }
    }

    function getUserIdInAddressMap(string idCartNo) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        return addressMap[idCartNo];
      }
      return 0;
    }

    function setUserIdToAddressMap(string idCartNo, address accountAddress) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        addressMap[idCartNo] = accountAddress;
        return true;
      }
      return false;
    }

    function getActiveInUsersMap(address userId) public constant returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].active;
      }
      return false;
    }

    function setActiveToUsersMap(address userId, bool active) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].active = active;
        return true;
      }
      return false;
    }

    function getAccountAddressInUsersMap(address userId) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].accountAddress;
      }
      return 0;
    }

    function setAccountAddressToUsersMap(address userId, address accountAddress) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].accountAddress = accountAddress;
        return true;
      }
      return false;
    }

    function getPublicKeyInUsersMap(address userId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].publicKey;
      }
      return "";
    }

    function setPublicKeyToUsersMap(address userId, string publicKey) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].publicKey = publicKey;
        return true;
      }
      return false;
    }

    function getIdCartNoInUsersMap(address userId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].idCartNo;
      }
      return "";
    }

    function setIdCartNoToUsersMap(address userId, string idCartNo) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].idCartNo = idCartNo;
        return true;
      }
      return false;
    }

    function getDetailInUsersMap(address userId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].detail;
      }
      return "";
    }

    function setDetailToUsersMap(address userId, string detail) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].detail = detail;
        return true;
      }
      return false;
    }

    function getTimeInUsersMap(address userId) public constant returns (uint){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].time;
      }
      return 0;
    }

    function setTimeToUsersMap(address userId, uint time) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].time = time;
        return true;
      }
      return false;
    }

    function addUserToUsersMap(address userId,address accountAddress,string publicKey,string idCartNo
    ,string detail,uint time) public returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId] = Users(true,accountAddress,publicKey,idCartNo,detail,time);
        return userId;
      }
      return 0;
    }

    function delUserInUsersMap(address userId) public returns (bool succ){
      if(msg.sender==invoker || msg.sender==owner){
        usersMap[userId].active = false;
        addressMap[usersMap[userId].idCartNo] = 0;
        return true;
      }
      return false;
    }

    function kill() public{
      if(msg.sender == owner){
        selfdestruct(owner);
      }
    }
}
