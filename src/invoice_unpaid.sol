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

contract InvoiceUnpaidNFT is NFT {

  using ECDSA for bytes32;

  // compact property for 'gross_amount'
  bytes constant internal GROSS_AMOUNT = hex"000100000000000e";
  //compact property for 'currency'
  bytes constant internal CURRENCY = hex"000100000000000d";
  //compact property for 'due_date'
  bytes constant internal DUE_DATE = hex"0001000000000016";

  struct TokenData {
    uint document_version;
    uint gross_amount;
    uint currency;
    uint due_date;
    address invoice_sender;
  }

  mapping (uint => TokenData) public data;

  constructor (address anchors_, address key_manager_, address identity_factory_) NFT("Invoice Unpaid NFT", "CNT_INV_UNPD", anchors_, key_manager_, identity_factory_) public {}

  // --- Utils ---
  function convertBytes(bytes memory b) public returns (uint256){
    uint256 number;
    for (uint i = 0; i < b.length; i++){
      number = number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))));
    }
    return number;
  }

  // --- Mint Method ---
  function mint(address usr, uint tkn, uint anchor, bytes32 data_root, bytes32 signatures_root, bytes memory signature, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts, bytes32[][] memory proofs) public {

  data[tkn] = TokenData(
    anchor,
    convertBytes(values[0]),
    convertBytes(values[1]),
    convertBytes(values[2]),
    usr
  );

  bytes32[] memory leaves = new bytes32[](4);
  leaves[0] = sha256(abi.encodePacked(GROSS_AMOUNT, values[0], salts[0]));
  leaves[1] = sha256(abi.encodePacked(CURRENCY, values[1], salts[1]));
  leaves[2] = sha256(abi.encodePacked(DUE_DATE, values[2], salts[2]));
  leaves[3] = sha256(abi.encodePacked(NEXT_VERSION, values[3], salts[3]));
//  leaves[4] = sha256(abi.encodePacked(NFTS, values[4], salts[4]));

  require(verify(proofs, data_root, leaves), "Validation of proofs failed.");
//  require(_latestDoc(data_root, bytesToUint(values[3])), "Document is not the latest version.");
//  require(_checkTokenData(tkn, properties[4], values[4]), "Invalid token data");
  require(_checkAnchor(anchor, data_root, signatures_root), "Validation against document anchor failed.");
  _signed(anchor, data_root, signature);
  _mint(usr, tkn);
  }
}