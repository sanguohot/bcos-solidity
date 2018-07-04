pragma solidity ^0.4.2;
import "./ContractBase.sol";
import "./FilesPureData.sol";

contract FilesController is ContractBase("v2") {
  address owner;
  uint MAX_SIGN_LEN = 3;
  FilesPureData filesDataContract;

  event onAddFile(bytes32 fileId,address ownerAddress,bytes32[2] fileHash,bytes32[2] ipfsHash,bytes32[4] detail,uint time);
  event onAddSign(bytes32 fileId,address signerAddress,bytes32[4] signData);
  event onSetFileDetail(bytes32 fileId,bytes32[4] detail);
  event onDelFile(bytes32 fileId);

  function FilesController(address FilesDataContractAddress) public {
    owner = msg.sender;
    filesDataContract = FilesPureData(FilesDataContractAddress);
  }
  function isUserIdExist(bytes32 fileId) public constant returns (bool valid){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if (!filesDataContract.isUserIdExist(fileId, msg.sender)) {
      return false;
    }
    return true;
  }

  function getFileSignSize(bytes32 fileId) public constant returns (uint size) {
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return 0;
    }
    return filesDataContract.getFileSignSize(fileId);
  }

  function getFileSignerAddressByIndex(bytes32 fileId, uint index) public constant returns (address signerAddress) {
    if(index<0 || index>MAX_SIGN_LEN){
      return 0;
    }
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return 0;
    }
    return filesDataContract.getFileSignerAddressByIndex(fileId, index);
  }

  function getFileSignDataByIndex(bytes32 fileId, uint index) public constant returns (bytes32[4] signData) {
    if(index<0 || index>MAX_SIGN_LEN){
      return [bytes32(0),bytes32(0),bytes32(0),bytes32(0)];
    }
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return [bytes32(0),bytes32(0),bytes32(0),bytes32(0)];
    }
    return filesDataContract.getFileSignDataByIndex(fileId, index);
  }

  function getFileBasic(bytes32 fileId) public constant returns (address ownerAddress, bytes32[2] fileHash, bytes32[2] ipfsHash, uint signSize, uint time) {
    if(!filesDataContract.getActiveInFilesMap(fileId)){
      return (0,[bytes32(0),bytes32(0)],[bytes32(0),bytes32(0)],0,0);
    }
    return (
      filesDataContract.getUserIdInFilesMap(fileId),
      filesDataContract.getFileHashInFilesMap(fileId),
      filesDataContract.getIpfsHashInFilesMap(fileId),
      filesDataContract.getFileSignSize(fileId),
      filesDataContract.getTimeInFilesMap(fileId)
    );
  }

  function getFileDetail(bytes32 fileId) public constant returns (bytes32[4] detail) {
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return ([bytes32(0),bytes32(0),bytes32(0),bytes32(0)]);
    }
    return (
      filesDataContract.getDetailInFilesMap(fileId)
    );
  }

  function addFileSigner(bytes32 fileId, bytes32[4] signData) public returns (bool succ){
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

  function addFile(bytes32 fileId, bytes32[4] signData, bytes32[2] fileHash, bytes32[2] ipfsHash, bytes32[4] detail, uint time) public returns (bytes32){
    if (filesDataContract.getActiveInFilesMap(fileId)){
        return "";
    }
    fileId = filesDataContract.addFile(fileId, msg.sender, signData, fileHash, ipfsHash, detail, time);
    if(fileId == 0){
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

  function setFileDetail(bytes32 fileId, bytes32[4] detail) public returns (bool succ){
    if (!filesDataContract.getActiveInFilesMap(fileId)) {
      return false;
    }
    if(filesDataContract.setDetailToFilesMap(fileId, msg.sender, detail)){
      onSetFileDetail(fileId, detail);
      return true;
    }
    return false;
  }

  function delFile(bytes32 fileId) public returns (bool succ){
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
