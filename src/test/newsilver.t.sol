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
import "../newsilver.sol";

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

contract TestNFT is NFT {
    constructor (address anchors_) NFT("Newsilver Loan NFT", "NSLN", anchors_) public {
    }
    function checkAnchor(uint anchor, bytes32 droot, bytes32 sigs) public returns (bool) {
        return true;
    }
}

contract NFTTest is DSTest {
    NewSilverLoanNFT nft;
    address         self;
    User            usr1;
    AnchorMock      anchors;

    function setUp() public {
        self = address(this);
        usr1 = new User();
        anchors = new AnchorMock();
        nft = new NewSilverLoanNFT(address(anchors));
    }

    function testMint() public logs_gas {

        // Set a bunch of values

        bytes32 sigs = 0xab3a51423550a6ac6a5ae3b07438fe4a16a7ebe3119352200a348af581b83d5c;
        bytes32 data_root = 0x9a5962acaca36b0607e4c46733219a2aa6abc29c41ed6988f19dc86865743cf5;
        bytes32 root = 0x11ac8d72d72354e3e64271878b698f9e770619ace3e7c5d6aa02968f729b453f;

        // bytes memory prop2 = hex"010000000000001cc559f889f1afe5f0e8d3ad327b66c9b2facadb9918e2ba45963fe76e590f9e4200000005";
        // bytes memory prop3 = hex"010000000000001cdb691b0c78e9e1432d354d52e26b3cd5054cd1261c4272bf8fce2bcf285908f300000005";

        // bytes32 val2 = 0x00000000000000000000000000000000000000000000000000000000000003e8;
        // bytes32 val3 = 0x00000000000000000000000000000000000000000000000000000000000007d0;

        // bytes32 salt2 = 0xf6fda2e48246f91c98e317377f3514298d221f7e93d62a315b9a956f33c7e594;
        // bytes32 salt3 = 0x038fea1f64d9925ce096e37db05f8bd6add09493574f29e0b40d6a48ea616379;

        bytes32[] memory salts = new bytes32[](1);
        salts[0] = 0xc0798a18953192518377f216f97e7a8b42249451664a39f9e52e7ee32045a0eb;
        // salts[1] = salt2;
        // salts[2] = salt3;

        bytes[] memory properties = new bytes[](1);
        properties[0] = hex"010000000000001cdb691b0c78e9e1432d354d52e26b3cd5054cd1261c4272bf8fce2bcf285908f300000005";
        // properties[1] = prop2;
        // properties[2] = prop3;

        bytes32[] memory values = new bytes32[](1);
        values[0] = 0x0000000000000000000000000000000000000000000000000000000000000064;
        //values[1] = val2;
        //values[2] = val3;

        bytes32[][] memory proofs = new bytes32[][](1);
        proofs[0] = new bytes32[](6);
        proofs[0][0] = 0xb77b0c26c232d21b5392643c29a07aad367411049b9ee50ae1a4377d5c25a079;
        proofs[0][1] = 0x298a3288a3590a18ad0000eab86b87182432424ca2cafd0ad983b179accd743f;
        proofs[0][2] = 0x43ee93a2023b43b061690614785dfe8cc978b686cd1a459af4028e1e53f02771;
        proofs[0][3] = 0x956a7fe14077ba295dc9f3aa58e7dd60e869cdc4b7172297f037a93e84faf55d;
        proofs[0][4] = 0x9c733d7a69131bbda95f765467e0533bbad0f9380bf759e2883d3a7e00075962;
        proofs[0][5] = 0x904a689147f7d2a86a39d8f4b542aa72f95ef86c872904640c47e0519b378e6a;


        bytes32 leaf0 = sha256(abi.encodePacked(properties[0], values[0], salts[0]));
        bytes32[] memory leaves = new bytes32[](3);
        leaves[0] = leaf0;

        // Setting AnchorMock to return a given root
        anchors.file(root, 0);

         // Test that the mint method works
        nft.mint(address(usr1), 1, 0, data_root, sigs, properties, values, salts, proofs);
        assertEq(nft.ownerOf(1), address(usr1));
    }

}
