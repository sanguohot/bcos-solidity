pragma solidity ^0.4.2;
import "./ContractBase.sol";
import "./FilesPureData.sol";

contract FilesController is ContractBase("v2") {
  address owner;
  uint MAX_SIGN_LEN = 3;
  FilesPureData filesDataContract;

  event onAddFile(string fileId,address ownerAddress,string fileHash,string ipfsHash,string detail,uint time);
  event onAddSign(string fileId,address signerAddress,string signData);
  event onSetFileDetail(string fileId,string detail);
  event onDelFile(string fileId);

  function FilesController(address FilesDataContractAddress) public {
    owner = msg.sender;
    filesDataContract = FilesPureData(FilesDataContractAddress);
  }
  function isUserIdExist(string fileId) public constant returns (bool valid){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if (!filesDataContract.isUserIdExist(fileId, msg.sender)) {
      return false;
    }
    return true;
  }

  function getFileSignSize(string fileId) public constant returns (uint size) {
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return 0;
    }
    return filesDataContract.getFileSignSize(fileId);
  }

  function getFileSignerAddressByIndex(string fileId, uint index) public constant returns (address signerAddress) {
    if(index<0 || index>MAX_SIGN_LEN){
      return 0;
    }
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return 0;
    }
    return filesDataContract.getFileSignerAddressByIndex(fileId, index);
  }

  function getFileSignDataByIndex(string fileId, uint index) public constant returns (string signData) {
    if(index<0 || index>MAX_SIGN_LEN){
      return "";
    }
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return "";
    }
    return filesDataContract.getFileSignDataByIndex(fileId, index);
  }

  function getFileBasic(string fileId) public constant returns (address ownerAddress, string fileHash, string ipfsHash, uint signSize, uint time) {
    if(!filesDataContract.getActiveInFilesMap(fileId)){
      return (0,"","",0,0);
    }
    return (
      filesDataContract.getUserIdInFilesMap(fileId),
      filesDataContract.getFileHashInFilesMap(fileId),
      filesDataContract.getIpfsHashInFilesMap(fileId),
      filesDataContract.getFileSignSize(fileId),
      filesDataContract.getTimeInFilesMap(fileId)
    );
  }

  function getFileDetail(string fileId) public constant returns (string detail) {
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return ("");
    }
    return (
      filesDataContract.getDetailInFilesMap(fileId)
    );
  }

  function addFileSigner(string fileId, string signData) public returns (bool succ){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if(filesDataContract.addFileSigner(fileId, msg.sender, signData)){
      onAddSign(
        fileId,
        msg.sender,
        signData
      );
      return true;
    }
    return false;
  }

  function addFile(string signData, string fileHash, string ipfsHash, string detail, uint time) public returns (string fileId){
    if (filesDataContract.getActiveInFilesMap(fileId)){
        return "";
    }
    fileId = filesDataContract.addFile(msg.sender, signData, fileHash, ipfsHash, detail, time);
    bytes memory fileIdBytes = bytes(fileId);
    if(fileIdBytes.length == 0){
      return "";
    }
    onAddFile(
      fileId,
      msg.sender,
      fileHash,
      ipfsHash,
      detail,
      time
    );
    onAddSign(
      fileId,
      msg.sender,
      signData
    );
    return fileId;
  }

  function setFileDetail(string fileId, string detail) public returns (bool succ){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if(filesDataContract.setDetailToFilesMap(fileId, msg.sender, detail)){
      onSetFileDetail(fileId, detail);
      return true;
    }
    return false;
  }

  function delFile(string fileId) public returns (bool succ){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if(filesDataContract.delFile(fileId, msg.sender)){
      onDelFile(
        fileId
      );
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
