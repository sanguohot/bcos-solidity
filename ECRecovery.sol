pragma solidity ^0.4.0;
contract ECRecovery {
    // prikey: '0c31d730db5e4c8e75364cbaab0db79346bf7b9aca355381c783edd1bc479135',
    // pubkey: '93f242644681b43c3432e96ab5cd35eb53bfb7595a823e4e04057158597a3865ae3b566aad7930cb70270b2706e15b76a0bf2c923bca21be08889f78e4bc0006',
    // address: '0x40bf116963ef22eaa4c81b2267c5568f9ce16ca0',
    // _message(rlphash message): 0xba6047bc03efffe46d2c973aae0154aab76d8c04024e85a2dc7d813426789581
    // _r: 0x96c53c2c2d5f6cfc64cc70316bb6a77194408f339e1c2c5cfd106b819c26e03c
    // _s: 0x377fe11803a556e209b4f8056908bb60ebafa5c46cc15ae10abc1bf272cc636f
    // _v: 27
    // output: 0x40BF116963EF22EAA4c81B2267C5568f9Ce16cA0
    // verify ok
    function verify(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s) public constant returns (address) {
        address signer = ecrecover(_message, _v, _r, _s);
        return signer;
    }
}