//SPDX-License-Identifier:MIT

pragma solidity ^0.8.1.0;

contract ProofOfExistence2 {

  // state
  bytes32[] private proofs;
  mapping (bytes32 => address) storedBy;
  mapping (bytes32 => uint256) storedOn;


  // store a proof of existence in the contract state
  // *transactional function*
  function storeProof(bytes32 proof) 
    public 
  {
    proofs.push(proof);
  }

  // calculate and store the proof for a document
  // *transactional function*
  function notarize(string calldata document) 
    external 
  {
    bytes32 proof = proofFor(document);
    storedBy[proof] = msg.sender;
    storedOn[proof] = block.timestamp;
    storeProof(proof);


  }

  // helper function to get a document's sha256
  // *read-only function*
  function proofFor(string memory document) 
    pure 
    public 
    returns (bytes32) 
  {
    return sha256(abi.encodePacked(document));
  }

  // check if a document has been notarized
  // *read-only function*
  function checkDocument(string memory document) 
    public 
    view 
    returns (bool) 
  {
    bytes32 proof = proofFor(document);
    return hasProof(proof);
  }

  // returns true if proof is stored
  // *read-only function*
  function hasProof(bytes32 proof) 
    internal 
    view 
    returns (bool) 
  {
   for(uint i =0 ;i < proofs.length ;i ++){
     if(proofs[i] == proof){
       return true;
     }
     else{
       return false;
     }
   }

}
}
