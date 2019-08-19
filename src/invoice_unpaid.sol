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

  // compact property for 'gross_amount'
  bytes constant internal GROSS_AMOUNT = hex"010000000000001cf42b919dfcd704d9307ff04e74b84fdcf8a974d9d0aef3478bded08f06f9759000000005";
  //compact property for 'currency'
  bytes constant internal CURRENCY = hex"010000000000001c466e5b9cd57fa444cceaa8e5b053ddd58d05cbbcf162a54d6ccd08492ef36dfd00000004";
  //compact property for 'due_date'
  bytes constant internal DUE_DATE = hex"010000000000001c3852ef35dd7ac92c4dd36952e585e35f0534828d861d70a4528551e8a43d0ae000000005";
  //compact property for 'status'
  bytes constant internal STATUS = hex"010000000000001c073c1634c496cdb649d1afe0a312bbb4b7e1741b271542e4a436c3b8824b176100000004";

  struct TokenData {
    uint document_version;
    uint gross_amount;
    uint currency;
    bytes due_date;
    uint status;
    address invoice_sender;
  }

  mapping (uint => TokenData) public data;

  constructor (address anchors_) NFT("Invoice Unpaid NFT", "CNT_INV_UNPD", anchors_) public {}

  // --- Mint Method ---
  function mint(address usr, uint tkn, uint anchor, bytes32 data_root, bytes32 signatures_root, bytes memory signature, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts, bytes32[][] memory proofs) public {

  data[tkn] = TokenData(
    anchor,
    abi.decode(values[0], (uint)),
    bytesToUint(values[1]),
    bytesToUint(values[2]),
    bytesToUint(values[3]),
    usr
  );

  bytes32[] memory leaves = new bytes32[](3);
  leaves[0] = sha256(abi.encodePacked(GROSS_AMOUNT, values[0], salts[0]));
  leaves[1] = sha256(abi.encodePacked(CURRENCY, values[1], salts[1]));
  leaves[2] = sha256(abi.encodePacked(DUE_DATE, values[2], salts[2]));
  leaves[3] = sha256(abi.encodePacked(STATUS, values[3], salts[3]));
  leaves[4] = sha256(abi.encodePacked(NEXT_VERSION, values[4], salts[4]));
  leaves[5] = sha256(abi.encodePacked(NFTS, values[5], salts[5]));

  require(verify(proofs, data_root, leaves), "Validation of proofs failed.");
  require(_latestDoc(data_root, bytesToUint(values[4])), "Document is not the latest version.");
  require(_checkTokenData(tkn, properties[5], values[5]), "Invalid token data");
  require(_checkAnchor(anchor, data_root, signatures_root), "Validation against document anchor failed.");
  _signed(anchor, data_root, signature);
  _mint(usr, tkn);
  }
}