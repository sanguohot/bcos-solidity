pragma solidity ^0.4.2;
import "./ContractBase.sol";
import "./UsersPureData.sol";

contract UsersController is ContractBase("v2") {
  address owner;
  UsersPureData usersDataContract;

  function UsersController(address usersDataContractAddress) public {
    owner = msg.sender;
    usersDataContract = UsersPureData(usersDataContractAddress);
  }

  event onAddUser(address accountAddress,bytes32[2] publicKey,bytes32 idCartNo,bytes32[8] detail);
  event onSetUserDetail(address accountAddress,bytes32[8] detail);
  event onDelUser(address accountAddress,bytes32[2] publicKey,bytes32 idCartNo,bytes32[8] detail);

  function getUserIdByIdCartNo(bytes32 idCartNo) public constant returns (address accountAddress){
    return usersDataContract.getUserIdInAddressMap(idCartNo);
  }

  function getUserBasic() public constant returns (address accountAddress,bytes32[2] publicKey,bytes32 idCartNo) {
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
      return (0, [bytes32(0),bytes32(0)], bytes32(0));
    }
    return (
      usersDataContract.getAccountAddressInUsersMap(msg.sender),
      usersDataContract.getPublicKeyInUsersMap(msg.sender),
      usersDataContract.getIdCartNoInUsersMap(msg.sender)
    );
  }

  function getUserDetail() public constant returns (bytes32[8] detail) {
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
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
    return (
      usersDataContract.getDetailInUsersMap(msg.sender)
    );
  }

  function addUser(address accountAddress,bytes32[2] publicKey,bytes32 idCartNo
  ,bytes32[8] detail,uint time) public returns (address userId){
    userId = msg.sender;
    if(accountAddress==0 || idCartNo==0 || time==0){
      return 0;
    }
    if(publicKey[0]==0 && publicKey[1]==0){
      return 0;
    }
    if(usersDataContract.getUserIdInAddressMap(idCartNo) != 0){
      return 0;
    }

    if (usersDataContract.getActiveInUsersMap(userId)){
      return 0;
    }
    usersDataContract.addUserToUsersMap(userId,accountAddress,publicKey,idCartNo,detail,time);
    usersDataContract.setUserIdToAddressMap(idCartNo, userId);
    onAddUser(
      accountAddress,
      publicKey,
      idCartNo,
      detail
    );
    return userId;
  }

  function setUserDetail(bytes32[8] detail) public returns (bool succ){
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
      return false;
    }

    // onSetUserDetail(userId,detail);
    return usersDataContract.setDetailToUsersMap(msg.sender, detail);
  }

  function delUser() public returns (bool succ){
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
      return false;
    }
    usersDataContract.delUserInUsersMap(msg.sender);
    onDelUser(
      usersDataContract.getAccountAddressInUsersMap(msg.sender),
      usersDataContract.getPublicKeyInUsersMap(msg.sender),
      usersDataContract.getIdCartNoInUsersMap(msg.sender),
      usersDataContract.getDetailInUsersMap(msg.sender)
    );
    return true;
  }

  function kill() public{
    if(msg.sender == owner){
      selfdestruct(owner);
    }
  }
}
