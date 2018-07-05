pragma solidity ^0.4.2;
import "./ContractBase.sol";

contract UsersPureData is ContractBase("v2") {
    address owner;
    address invoker;
    struct Users{
      bool active;
      address accountAddress;
      bytes32[4] publicKey;
      bytes32 idCartNo;
      bytes32[8] detail;
      uint time;
    }

    // userId(address) => Users 保存用户列表
    mapping(address=>Users) usersMap;
    // idCartNo => userId(address) 控制idCartNo唯一
    mapping(bytes32=>address) addressMap;
    // 保存用户列表 方便以后导出 只增不减 注意唯一性
    // 这里不考虑普通索引的问题 使用普通索引请先导入MongoDB或者关系型数据库进行检索
    address[] usersList;

    event onSetUsersPureDataInvokerAddress(address invokerAddress);

    function UsersPureData() public {
      owner = msg.sender;
      setInvoker(owner);
    }

    function setInvoker(address invokerAddress) public{
      if(msg.sender==owner && invokerAddress!=0){
        invoker = invokerAddress;
        onSetUsersPureDataInvokerAddress(invoker);
      }
    }

    function getUsersListSize() public constant returns (uint){
      return usersList.length;
    }
    function getUserIdInUsersList(uint index) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        if(index>=0 && index<usersList.length){
          return usersList[index];
        }
      }
      return 0;
    }

    function setUserIdToUsersList(address userId) private returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && usersMap[userId].time==0){
          usersList.push(userId);
          return true;
        }
        return false;
      }
      return false;
    }

    function getUserIdInAddressMap(bytes32 idCartNo) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        return addressMap[idCartNo];
      }
      return 0;
    }

    function setUserIdToAddressMap(bytes32 idCartNo, address userId) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && addressMap[idCartNo]==0){
          addressMap[idCartNo] = userId;
          return true;
        }
        return false;
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
        if(userId!=0 && usersMap[userId].time!=0){
          usersMap[userId].active = active;
          return true;
        }
        return false;
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
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].accountAddress = accountAddress;
          return true;
        }
        return false;
      }
      return false;
    }

    function getPublicKeyInUsersMap(address userId) public constant returns (bytes32[4]){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].publicKey;
      }
      return [bytes32(0), bytes32(0), bytes32(0), bytes32(0)];
    }

    function setPublicKeyToUsersMap(address userId, bytes32[2] publicKey) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].publicKey = publicKey;
          return true;
        }
        return false;
      }
      return false;
    }

    function getIdCartNoInUsersMap(address userId) public constant returns (bytes32){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].idCartNo;
      }
      return "";
    }

    function setIdCartNoToUsersMap(address userId, bytes32 idCartNo) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].idCartNo = idCartNo;
          return true;
        }
        return false;
      }
      return false;
    }

    function getDetailInUsersMap(address userId) public constant returns (bytes32[8]){
      if(msg.sender==invoker || msg.sender==owner){
        return usersMap[userId].detail;
      }
      return [
        bytes32(0),
        bytes32(0),
        bytes32(0),
        bytes32(0),
        bytes32(0),
        bytes32(0),
        bytes32(0),
        bytes32(0)
      ];
    }

    function setDetailToUsersMap(address userId, bytes32[8] detail) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].detail = detail;
          return true;
        }
        return false;
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
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].time = time;
          return true;
        }
        return false;
      }
      return false;
    }

    function addUserToUsersMap(address userId,address accountAddress,bytes32[4] publicKey,bytes32 idCartNo
    ,bytes32[8] detail,uint time) public returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && !usersMap[userId].active){
          setUserIdToUsersList(userId);
          usersMap[userId] = Users(true,accountAddress,publicKey,idCartNo,detail,time);
          addressMap[idCartNo] = userId;
          return userId;
        }
        return 0;
      }
      return 0;
    }

    function delUserInUsersMap(address userId) public returns (bool succ){
      if(msg.sender==invoker || msg.sender==owner){
        if(userId!=0 && usersMap[userId].active){
          usersMap[userId].active = false;
          addressMap[usersMap[userId].idCartNo] = 0;
          return true;
        }
        return false;
      }
      return false;
    }

    function kill() public{
      if(msg.sender == owner){
        selfdestruct(owner);
      }
    }
}
