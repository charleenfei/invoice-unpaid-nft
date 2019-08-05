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
import "../invoice_unpaid.sol";

contract User {
    function doMint(address registry, address usr) public {
    }
}

contract AnchorMock {
    bytes32 documentRoot;
    uint32  blockNumber;

    function file(bytes32 documentRoot_, uint32 blockNumber_) public {
        documentRoot = documentRoot_;
        blockNumber = blockNumber;
    }

    function getAnchorById(uint id) public returns (uint, bytes32, uint32) {
        return (id, documentRoot, blockNumber);
    }
}

contract NFTTest is DSTest {
//    InvoiceUnpaidNFT nft;
//    address         self;
//    User            usr1;
//    AnchorMock      anchors;
//
//    function setUp() public {
//        self = address(this);
//        usr1 = new User();
//        anchors = new AnchorMock();
//        nft = new InvoiceUnpaidNFT(address(anchors));
//    }
//
//    function testMint() public logs_gas {
//
//        // Set a bunch of values
//        bytes32 sigs = ;
//        bytes32 data_root = ;
//        bytes32 root = ;
//
//        bytes[] memory properties = new bytes[](3);
//        properties[0] = ;
//        properties[1] = ;
//        properties[2] = ;
//
//        bytes[] memory values = new bytes[](3);
//        values[0] = ;
//        values[1] = ;
//        values[2] = ;
//
//        bytes32[] memory salts = new bytes32[](3);
//        salts[0] = ;
//        salts[1] = ;
//        salts[2] = ;
//
//        bytes32[][] memory proofs = new bytes32[][](3);
//        proofs[0] = new bytes32[](6);
//        proofs[0][0] = ;
//        proofs[0][1] = ;
//        proofs[0][2] = ;
//        proofs[0][3] = ;
//        proofs[0][4] = ;
//        proofs[0][5] = ;
//
//        proofs[1] = new bytes32[](6);
//        proofs[1][0] = ;
//        proofs[1][1] = ;
//        proofs[1][2] = ;
//        proofs[1][3] = ;
//        proofs[1][4] = ;
//        proofs[1][5] = ;
//
//        proofs[2] = new bytes32[](6);
//        proofs[2][0] = ;
//        proofs[2][1] = ;
//        proofs[2][2] = ;
//        proofs[2][3] = ;
//        proofs[2][4] = ;
//        proofs[2][5] = ;
//
//        // Setting AnchorMock to return a given root
//        anchors.file(root, 0);
//
//         // Test that the mint method works
//        nft.mint(address(usr1), 1, 0, data_root, sigs, properties, values, salts, proofs);
//        assertEq(nft.ownerOf(1), address(usr1));
//    }
}
