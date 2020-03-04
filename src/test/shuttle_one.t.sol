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
import "../shuttle_one.sol";

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

    function getAnchorById(uint id) public view returns (uint, bytes32, uint32) {
        return (id, documentRoot, blockNumber);
    }
}

contract ShuttleOneTest is DSTest {
    ShuttleOneNFT nft;
    User usr1;
    AnchorMock anchors;

    function testMint() logs_gas public {
        usr1 = new User();
        anchors = new AnchorMock();
        nft = new ShuttleOneNFT(address(anchors));

        // set up a bunch of values
        bytes32 signing_root = 0xb15edca98d4c529a03a1d2c74f8cab0c8420ca6ff19eb8e890a22a41f524850d;
        bytes32 doc_root = 0xf187e511a2e967d6fc7862cdde7812083deea828458dd226fc984b481a797241;

        bytes[] memory properties = new bytes[](4);
        properties[0] = hex"010000000000001c259e21397ec936e21c39634dd8f9aa5228da6fc101b9353c8a1d34200405365300000004";
        properties[1] = hex"010000000000001cc6c01cee2272c62554fb7f983110a166ce86258c12afb2a0f7bde6fc100e13fb00000004";
        properties[2] = hex"010000000000001c7f0609413f575326611e9c47d55e0732ec88c052ceac7c22af2d041a0b19b67300000005";
        properties[3] = hex"0100000000000014d86240f695014a41ef8288b2848a9c2ec655fd2f000000000000000000000000";

        bytes[] memory values = new bytes[](4);
        values[0] = hex"74657374";
        values[1] = hex"746573746c69656e";
        values[2] = hex"00000000000000000000000000000000000000000000006c6b935b8bbd400000";
        values[3] = hex"9a9fdc5a58d067d357d318f47c03bd06f1f43d38f3604282989f08fb6377fb14";

        bytes32[] memory salts = new bytes32[](4);
        salts[0] = 0xf675dc3a91a52954ff0bee51ad589f50b092b6c8c49e87d7b1ecc7cdf09a7134;
        salts[1] = 0x595abb6511a0f432e89416752400da1138d6a72a9a34bd6d33d2ed290b6f4b87;
        salts[2] = 0xc95dd29dbea805b92b4227bafc797f6ba0887bf7c9c7ddb4e2d3be05ba7dba1c;
        salts[3] = 0x2c8044bd6056e25ee4b02df49c9cd07f9783b02789b378e7b126fcb0fa2471d8;

        bytes32[][] memory proofs = new bytes32[][](4);
        proofs[0] = new bytes32[](7);
        proofs[0][0] = 0x099ccc7f35ac03b45c44ed7824afc5234db9302ff8e03838cc6d64e235c18745;
        proofs[0][1] = 0x05f71a03f23035e81ba1596f2ddc5326ce572807e05a834ed7af2b694ce76439;
        proofs[0][2] = 0x1bbf708557a592c6c50d6dec2a22b11861bba40779604e1eff91e19374806ab6;
        proofs[0][3] = 0x87261fee121ecc3933e4d3b10725041cccf63d0f2ff31b09acf9ec3d0d34fd23;
        proofs[0][4] = 0x0d7e623a246ec313d4465d38bc25ecdacc02a5f2061171a0f5a4654c212dd461;
        proofs[0][5] = 0x032e70d9dda61478f5ba4cb82fe94f0c71eb0101bc1735a924db66ab1afbd137;
        proofs[0][6] = 0xdb759e5c9af1e46a183bad2bc749cc9516cbc620697d3c110f2cb1dd4734eb26;


        proofs[1] = new bytes32[](3);
        proofs[1][0] = 0x97d71b6ca0b05fc160e269eb1e06008b145c1d924436abbebae1bcec19c6b594;
        proofs[1][1] = 0x621b17da16b929c54af97175058f5574c2da3c25d4ae1fbd6ccd9fb3315ff352;
        proofs[1][2] = 0x086ee097b97a21a5ba2daf0ad57bc517a8b54f74cef5a16c470b19fcd06bc80e;

        proofs[2] = new bytes32[](2);
        proofs[2][0] = 0x4a2a5c3cd782f9c7b1982fdc03588d6d436833d9710f29459ee5fae68bac0186;
        proofs[2][1] = 0x2b32dd3435b94e46095db13676f9d318fadd566c1aad40bb498068d8de88f88b;

        proofs[3] = new bytes32[](5);
        proofs[3][0] = 0xd826a1a5b96ad6544da92a6f7f79e0248fbcd0ac46389085922eb71931468854;
        proofs[3][1] = 0x1d06288daf684edd44a8c2836458e6ad136b967f98644cb5977b8b508c067933;
        proofs[3][2] = 0xb066064d5073a00809215ca7c07c4239ef1405ae6e50986061cdeedb8184209d;
        proofs[3][3] = 0xe2cd1e185d49dfbf512cdb2e5d7e4f0e1361e87593b789d1f6527a6cc276cd4c;
        proofs[3][4] = 0x9430c075479a157983ac6adf8febe71cf31eeaa0c8645ff0c635fbed116f4571;

        // Setting AnchorMock to return a given root
        anchors.file(doc_root, 0);

        // Test that the mint method works
        nft.mint(address(usr1), 1, 0, signing_root, properties, values, salts, proofs);
        assertEq(nft.ownerOf(1), address(usr1));
    }
}
