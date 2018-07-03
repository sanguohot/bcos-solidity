pragma solidity ^0.4.2;
import "./ContractBase.sol";

contract FilesPureData is ContractBase("v2") {
    address owner;
    address invoker;
    struct Files{
        bool active;
        address userId;
        address[] signerAddressList;
        string[] signDataList;
        string fileHash;
        string ipfsHash;
        string detail;
        uint time;
    }
    mapping(string=>Files) filesMap;

    event onSetFilesPureDataInvokerAddress(address invokerAddress);

    function FilesPureData() public {
      owner = msg.sender;
      setInvoker(owner);
    }

    function setInvoker(address invokerAddress) public{
      if(msg.sender == owner){
        invoker = invokerAddress;
        onSetFilesPureDataInvokerAddress(invoker);
      }
    }

    function getActiveInFilesMap(string fileId) public constant returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].active;
      }
      return false;
    }

    function setActiveToFilesMap(string fileId, address userId, bool active) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].active = active;
          return true;
        }
      }
      return false;
    }

    function getUserIdInFilesMap(string fileId) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].userId;
      }
      return 0;
    }

    function setUserIdToFilesMap(string fileId, address userId, address newUserId) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].userId = newUserId;
          return true;
        }
      }
      return false;
    }

    function getFileHashInFilesMap(string fileId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].fileHash;
      }
      return "";
    }

    function setFileHashToFilesMap(string fileId, address userId, string fileHash) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].fileHash = fileHash;
          return true;
        }
      }
      return false;
    }

    function getIpfsHashInFilesMap(string fileId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].ipfsHash;
      }
      return "";
    }

    function setIpfsHashToFilesMap(string fileId, address userId, string ipfsHash) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].ipfsHash = ipfsHash;
          return true;
        }
      }
      return false;
    }

    function getDetailInFilesMap(string fileId) public constant returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].detail;
      }
      return "";
    }

    function setDetailToFilesMap(string fileId, address userId, string detail) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].detail = detail;
          return true;
        }
      }
      return false;
    }

    function getTimeInFilesMap(string fileId) public constant returns (uint){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].time;
      }
      return 0;
    }

    function setTimeToFilesMap(string fileId, address userId, uint time) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].time = time;
          return true;
        }
      }
      return false;
    }

    function getFileSignSize(string fileId) public constant returns (uint size) {
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].signerAddressList.length;
      }
      return 0;
    }

    function getFileSignerAddressByIndex(string fileId, uint index) public constant returns (address signerAddress) {
        if(msg.sender==invoker || msg.sender==owner){
          return filesMap[fileId].signerAddressList[index];
        }
        return 0;
    }
    function isUserIdExist(string fileId, address userId) public constant returns (bool valid){
      valid = false;
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          return true;
        }
        for(uint i=0; i<getFileSignSize(fileId); i++){
          address signerAddress = filesMap[fileId].signerAddressList[i];
          if(signerAddress==userId){
            valid = true;
            break;
          }
        }
      }

      return valid;
    }

    function getFileSignDataByIndex(string fileId, uint index) public constant returns (string) {
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].signDataList[index];
      }
      return "";
    }

    function addFileSigner(string fileId, address userId, string signData) public returns (bool succ){
      if(msg.sender==invoker || msg.sender==owner){
        if(!isUserIdExist(fileId, userId)){
          filesMap[fileId].signerAddressList.push(userId);
          filesMap[fileId].signDataList.push(signData);
          return true;
        }
      }
      return false;
    }

    function addFile(address userId, string signData, string fileHash, string ipfsHash, string detail, uint time) public returns (string){
      if(msg.sender==invoker || msg.sender==owner){
        string memory fileId = fileHash;
        address[] memory signerAddressList = new address[](1);
        string[] memory signDataList = new string[](1);
        signerAddressList[0] = userId;
        signDataList[0] = signData;
        filesMap[fileId] = Files(
          true,
          userId,
          signerAddressList,
          signDataList,
          fileHash,
          ipfsHash,
          detail,
          time
        );
        return fileId;
      }
      return "";
    }

    function delFile(string fileId, address userId) public returns (bool succ){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].active = false;
          return true;
        }
      }
      return false;
    }

    function kill() public{
      if(msg.sender == owner){
        selfdestruct(owner);
      }
    }
}
