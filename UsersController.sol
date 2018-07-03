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

  event onAddUser(address accountAddress,string publicKey,string idCartNo,string detail);
  event onSetUserDetail(address accountAddress,string detail);
  event onDelUser(address accountAddress,string publicKey,string idCartNo,string detail);

  function getUserIdByIdCartNo(string idCartNo) public constant returns (address accountAddress){
    return usersDataContract.getUserIdInAddressMap(idCartNo);
  }

  function getUserBasic() public constant returns (address accountAddress,string publicKey,string idCartNo) {
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
      return (0, "", "");
    }
    return (
      usersDataContract.getAccountAddressInUsersMap(msg.sender),
      usersDataContract.getPublicKeyInUsersMap(msg.sender),
      usersDataContract.getIdCartNoInUsersMap(msg.sender)
    );
  }

  function getUserDetail() public constant returns (string detail) {
    if (!usersDataContract.getActiveInUsersMap(msg.sender)) {
      return ("");
    }
    return (
      usersDataContract.getDetailInUsersMap(msg.sender)
    );
  }

  function addUser(address accountAddress,string publicKey,string idCartNo
  ,string detail,uint time) public returns (address userId){
    userId = msg.sender;
    if(accountAddress == 0){
      return 0;
    }
    if(usersDataContract.getUserIdInAddressMap(idCartNo) != 0){
      return 0;
    }
    bytes memory publicKeyBytes = bytes(publicKey);
    if(publicKeyBytes.length == 0){
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

  function setUserDetail(string detail) public returns (bool succ){
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
