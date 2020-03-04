// Copyright (C) 2019 Centrifuge GmbH

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity >=0.4.23;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "privacy-enabled-erc721/nft.sol";

contract ShuttleOneNFT is NFT {

  // compact property for 'collateral_type'
  bytes constant internal collateral_type = hex"010000000000001c259e21397ec936e21c39634dd8f9aa5228da6fc101b9353c8a1d34200405365300000004";
  //compact property for 'lien'
  bytes constant internal lien = hex"010000000000001cc6c01cee2272c62554fb7f983110a166ce86258c12afb2a0f7bde6fc100e13fb00000004";
  //compact property for 'requested_loan_amount'
  bytes constant internal requested_loan_amount = hex"010000000000001c7f0609413f575326611e9c47d55e0732ec88c052ceac7c22af2d041a0b19b67300000005";
  //compact property for 'requested_tenor'
  bytes constant internal requested_tenor = hex"0100000000000014d86240f695014a41ef8288b2848a9c2ec655fd2f000000000000000000000000";


  struct TokenData {
    uint collateral_type;
    uint lien;
    uint requested_loan_amount;
    uint requested_tenor;
  }

  mapping (uint => TokenData) public data;

  constructor (address anchors_) NFT("Shuttle One NFT", "SHUTTLE", anchors_) public {}

  // --- Utils ---
  function bytesToUint(bytes memory b) public returns (uint256){
    uint256 number;
    for (uint i = 0; i < b.length; i++){
      number = number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))));
    }
    return number;
  }

  // --- Mint Method ---
  function mint(address usr, uint tkn, uint anchor, bytes32 document_root, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts, bytes32[][] memory proofs) public {

  data[tkn] = TokenData(
    bytesToUint(values[0]),
    bytesToUint(values[1]),
    abi.decode(values[2], (uint)),
    bytesToUint(values[3])
  );

  bytes32[] memory leaves = new bytes32[](4);
    leaves[0] = sha256(abi.encodePacked(collateral_type, values[0], salts[0]));
    leaves[1] = sha256(abi.encodePacked(lien, values[1], salts[1]));
    leaves[2] = sha256(abi.encodePacked(requested_loan_amount, values[2], salts[2]));
    leaves[3] = sha256(abi.encodePacked(requested_tenor, values[3], salts[3]));

  require(verify(proofs, document_root, leaves), "Validation of proofs failed.");
  _mint(usr, tkn);
  }
}
