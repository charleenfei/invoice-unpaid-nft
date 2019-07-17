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
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "privacy-enabled-erc721/nft.sol";


contract NewSilverLoanNFT is NFT {
    // compact property for 'amount'
    bytes constant internal AMOUNT = hex"010000000000001cdb691b0c78e9e1432d354d52e26b3cd5054cd1261c4272bf8fce2bcf285908f300000005";
    // compact property for 'asis_value'
    bytes constant internal ASIS_VALUE = hex"010000000000001cc559f889f1afe5f0e8d3ad327b66c9b2facadb9918e2ba45963fe76e590f9e4200000005";
    // compact property for 'rehab_value'
    bytes constant internal REHAB_VALUE = hex"010000000000001cc26ac898297e7f1c950218e45d1933059ab9c2b284aac57b36e1f6cd46829ead00000005";

    struct TokenData {
        uint document_version;
        uint amount;
        uint asis_value;
        uint rehab_value;
        address borrower;
    }
    mapping (uint => TokenData) public data;

    constructor (address anchors_) NFT("Newsilver Loan NFT", "NSLN", anchors_) public {
    }

    // --- Utils ---

		function bytesToUint(bytes memory b) public returns (uint256){
      uint256 number;
      for (uint i = 0; i < b.length; i++){
              number = number + uint8(b[i]) * (2 ** (8 * (b.length - (i + 1))));
            }
      return number;
    }

    // --- Mint Method ---

    function mint(address usr, uint tkn, uint anchor, bytes32 data_root, bytes32 signatures_root, bytes[] memory properties, bytes[] memory values, bytes32[] memory salts, bytes32[][] memory proofs) public {

      data[tkn] = TokenData(
        anchor,
        bytesToUint(values[0]),
        bytesToUint(values[1]),
        bytesToUint(values[2]),
        usr
      );

      bytes32[] memory leaves = new bytes32[](3);
			leaves[0] = sha256(abi.encodePacked(AMOUNT, values[0], salts[0]));
      leaves[1] = sha256(abi.encodePacked(ASIS_VALUE, values[1], salts[1]));
      leaves[2] = sha256(abi.encodePacked(REHAB_VALUE, values[2], salts[2]));

      require(verify(proofs, data_root, leaves), "Validation of proofs failed.");
      require(_checkAnchor(anchor, data_root, signatures_root), "Validation against document anchor failed.");
      _mint(usr, tkn);
    }
}


