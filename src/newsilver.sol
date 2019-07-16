// Copyright (C) 2019 lucasvo

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

import "ds-test/test.sol";
import "privacy-enabled-erc721/nft.sol";


contract NewSilverLoanNFT is NFT {

    // array of field names that are being proved
    bytes[] internal _mandatoryFields;

    // compact property for 'amount'
    bytes constant internal AMOUNT = hex"0x010000000000001cdb691b0c78e9e1432d354d52e26b3cd5054cd1261c4272bf8fce2bcf285908f300000005";
    // compact property for 'asis_value'
    bytes constant internal ASIS_VALUE = hex"0x010000000000001cc559f889f1afe5f0e8d3ad327b66c9b2facadb9918e2ba45963fe76e590f9e4200000005";
    // compact property for 'rehab_value'
    bytes constant internal REHAB_VALUE = hex"0x010000000000001cdb691b0c78e9e1432d354d52e26b3cd5054cd1261c4272bf8fce2bcf285908f300000005";

    struct TokenData {
        uint document_version;
        uint amount;
        uint asis_value;
        uint rehab_value;
        address borrower;
    }
    mapping (uint => TokenData) public data;

    constructor (address anchors_) NFT("Newsilver Loan NFT", "NSLN", anchors_) public {
      _mandatoryFields.push(AMOUNT);
      _mandatoryFields.push(ASIS_VALUE);
      _mandatoryFields.push(REHAB_VALUE);
    }

    function mint(address usr, uint tkn, uint anchor, bytes32 data_root, bytes32 signatures_root bytes[] memory properties bytes32[] memory values bytes32[] memory salts, [][]bytes32 proofs) public {

      bytes[] memory property_names =
      for (uint i = 0; i < 3; i++) {
      require(property[i] == _mandatoryFields[i], "Provided proof is not one of the mandatory fields.");
      }

      data[tkn] = TokenData(
        anchor,
        values[0],
        values[1],
        values[2],
        usr
      );

      bytes32[] memory leaves = new bytes32[](3);
      leafs[0] = (sha256(abi.encodePacked(properties[0], values[0], salt[0]))
      leafs[1] = (sha256(abi.encodePacked(properties[1], values[1], salt[1]))
      leafs[2] = (sha256(abi.encodePacked(properties[2], values[2], salt[2]))

      verify(leafs, proofs, root)
      // check anchor
      _mint(usr, tkn);
    }
}


