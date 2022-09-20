pragma solidity ^0.5.0;

contract ProofOfExistence1 {
      // state

      struct doc{
            address storedBy;
            uint storedOn;
      }

      
      bytes32 public proof;

      mapping(bytes32 => doc) docs;
       mapping(bytes32 => address) storedBy;
      mapping(bytes32 => uint256) storedOn;

      // calculate and store the proof for a document
      // *transactional function*
      function notarize(string memory document) public {
        proof = proofFor(document);
        storedBy[proof] = msg.sender;
        storedOn[proof] = block.timestamp;

      }

      // helper function to get a document's sha256
      // *read-only function*
      function proofFor(string memory document) public pure returns (bytes32) {
           return sha256(abi.encodePacked(document));
           
      }

}

