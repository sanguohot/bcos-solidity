pragma solidity ^0.4.2;
import "./ContractBase.sol";

contract FilesPureData is ContractBase("v2") {
    address owner;
    address invoker;
    struct Files{
        bool active;
        address userId;
        address[] signerAddressList;
        bytes32[4][] signDataList;
        bytes32[2] fileHash;
        bytes32[2] ipfsHash;
        bytes32[4] detail;
        uint time;
    }
    // 文件map
    mapping(bytes32=>Files) filesMap;
    // 文件列表 方便以后导出 只增不减 注意唯一性
    // 这里不考虑普通索引的问题 使用普通索引请先导入MongoDB或者关系型数据库进行检索
    bytes32[] filesList;

    event onSetFilesPureDataInvokerAddress(address invokerAddress);

    function FilesPureData() public {
      owner = msg.sender;
      setInvoker(owner);
    }

    function setInvoker(address invokerAddress) public{
      if(msg.sender==owner && invokerAddress!=0){
        invoker = invokerAddress;
        onSetFilesPureDataInvokerAddress(invoker);
      }
    }

    function getFilesListSize() public constant returns (uint){
      return filesList.length;
    }
    function getFileIdInFilesList(uint index) public constant returns (bytes32){
      if(msg.sender==invoker || msg.sender==owner){
        if(index>=0 && index<filesList.length){
          return filesList[index];
        }
      }
      return 0;
    }

    function setfileIdToFilesList(bytes32 fileId) private returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].time==0){
          filesList.push(fileId);
          return true;
        }
        return false;
      }
      return false;
    }

    function getActiveInFilesMap(bytes32 fileId) public constant returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].active;
      }
      return false;
    }

    function setActiveToFilesMap(bytes32 fileId, address userId, bool active) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].active = active;
          return true;
        }
      }
      return false;
    }

    function getUserIdInFilesMap(bytes32 fileId) public constant returns (address){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].userId;
      }
      return 0;
    }

    function setUserIdToFilesMap(bytes32 fileId, address userId, address newUserId) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].userId = newUserId;
          return true;
        }
      }
      return false;
    }

    function getFileHashInFilesMap(bytes32 fileId) public constant returns (bytes32[2]){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].fileHash;
      }
      return [bytes32(0), bytes32(0)];
    }

    function setFileHashToFilesMap(bytes32 fileId, address userId, bytes32[2] fileHash) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].fileHash = fileHash;
          return true;
        }
      }
      return false;
    }

    function getIpfsHashInFilesMap(bytes32 fileId) public constant returns (bytes32[2]){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].ipfsHash;
      }
      return [bytes32(0),bytes32(0)];
    }

    function setIpfsHashToFilesMap(bytes32 fileId, address userId, bytes32[2] ipfsHash) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].ipfsHash = ipfsHash;
          return true;
        }
      }
      return false;
    }

    function getDetailInFilesMap(bytes32 fileId) public constant returns (bytes32[4]){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].detail;
      }
      return [bytes32(0),bytes32(0),bytes32(0),bytes32(0)];
    }

    function setDetailToFilesMap(bytes32 fileId, address userId, bytes32[4] detail) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].detail = detail;
          return true;
        }
      }
      return false;
    }

    function getTimeInFilesMap(bytes32 fileId) public constant returns (uint){
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].time;
      }
      return 0;
    }

    function setTimeToFilesMap(bytes32 fileId, address userId, uint time) public returns (bool){
      if(msg.sender==invoker || msg.sender==owner){
        if(filesMap[fileId].userId == userId){
          filesMap[fileId].time = time;
          return true;
        }
      }
      return false;
    }

    function getFileSignSize(bytes32 fileId) public constant returns (uint size) {
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].signerAddressList.length;
      }
      return 0;
    }

    function getFileSignerAddressByIndex(bytes32 fileId, uint index) public constant returns (address signerAddress) {
        if(msg.sender==invoker || msg.sender==owner){
          return filesMap[fileId].signerAddressList[index];
        }
        return 0;
    }
    function isUserIdExist(bytes32 fileId, address userId) public constant returns (bool valid){
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

    function isSignDataExist(bytes32 fileId, bytes32[4] signData) public constant returns (bool valid){
      valid = false;
      if(msg.sender==invoker || msg.sender==owner){
        for(uint i=0; i<getFileSignSize(fileId); i++){
          bytes32[4] memory signDataInList = filesMap[fileId].signDataList[i];
          if(
              signDataInList[0]==signData[0] &&
              signDataInList[1]==signData[1] &&
              signDataInList[2]==signData[2] &&
              signDataInList[3]==signData[3]
          ){
            valid = true;
            break;
          }
        }
      }
      return valid;
    }

    function getFileSignDataByIndex(bytes32 fileId, uint index) public constant returns (bytes32[4]) {
      if(msg.sender==invoker || msg.sender==owner){
        return filesMap[fileId].signDataList[index];
      }
      return [bytes32(0),bytes32(0),bytes32(0),bytes32(0)];
    }

    function addFileSigner(bytes32 fileId, address userId, bytes32[4] signData) public returns (bool succ){
      if(msg.sender==invoker || msg.sender==owner){
        if(!isUserIdExist(fileId, userId) && !isSignDataExist(fileId, signData)){
          filesMap[fileId].signerAddressList.push(userId);
          filesMap[fileId].signDataList.push(signData);
          return true;
        }
      }
      return false;
    }

    function addFile(bytes32 fileId, address userId, bytes32[4] signData, bytes32[2] fileHash, bytes32[2] ipfsHash, bytes32[4] detail, uint time) public returns (bytes32){
      if(msg.sender==invoker || msg.sender==owner){
        if(!filesMap[fileId].active){
            setfileIdToFilesList(fileId);
            address[] memory signerAddressList = new address[](1);
            bytes32[4][] memory signDataList = new bytes32[4][](1);
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
      }
      return bytes32(0);
    }

    function delFile(bytes32 fileId, address userId) public returns (bool succ){
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
