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

contract AnchorMock {
    bytes32 documentRoot;
    uint32  blockNumber;

    function file(bytes32 documentRoot_, uint32 blockNumber_) public {
        documentRoot = documentRoot_;
        blockNumber = blockNumber_;
    }

    function getAnchorById(uint id) public view returns (uint, bytes32, uint32) {
        return (id, documentRoot, blockNumber);
    }
}

contract KeyManagerMock {
    bytes32 key;
    bytes32 value;
    uint purpose;
    uint[] mem;
    bool validPurpose;
    uint32 revoked;

    function file(bool validity_) public {
        validPurpose = validity_;
    }

    function file(uint32 revoked_) public {
        revoked = revoked_;
    }

    function keyHasPurpose(bytes32 pbKey, uint purpose_) public view returns (bool) {
        return validPurpose;
    }

    function getKey(bytes32 pbKey) public view returns (bytes32, uint[] memory, uint32) {
        return (value, mem, revoked);
    }
}

contract IDFactoryMock {
    address identity;
    bool validIdentity;

    function file(bool validity_) public {
        validIdentity = validity_;
    }

    function createdIdentity(address identity_) public returns (bool) {
        return validIdentity;
    }
}

contract InvoiceUnpaidNFTTest is DSTest {
    InvoiceUnpaidNFT nft;
    address         usr1;
    KeyManagerMock  key_manager;
    AnchorMock      anchors;
    IDFactoryMock   identity_factory;
    bytes[]         properties;
    bytes[]         values;
    bytes32[]       salts;
    bytes32[][]     proofs;
    bytes32[]       token_proof;
    bytes32[]       version_proof;
    bytes32         sigs;
    bytes           signature;
    bytes32         data_root;
    bytes32         root;

    function setUp() public {
        usr1 = address(1234);
        anchors = new AnchorMock();
        key_manager = new KeyManagerMock();
        identity_factory = new IDFactoryMock();
        nft = new InvoiceUnpaidNFT(address(anchors), address(key_manager), address(identity_factory));

        // set up a bunch of values
        sigs = 0xa42cfcb21740fbd16b4a48499f7d273611fa413b001f9f0fb476eb00d85b5eeb;
        data_root = 0xca87e9ba4fcfc9eb27594e18d14dc3fb094913e67c9aa3f19e0e3205dbb7dbfa;
        root = 0x7eba2627f27e0c2b49cd7f3aee6a11ca2637e1e07d5bb82b68253e7905ca074c;
        signature = hex"a2776063c2177a8e4be999fd337d939d03df0f341c50d2dac45dafad0008016e248cfb0076035c514dfc66af39e574bcc795a6af6b112a6ec90ff9291c766b7c01";

        properties = new bytes[](4);
        properties[0] = hex"000100000000000e";
        properties[1] = hex"000100000000000d";
        properties[2] = hex"0001000000000016";
        // version
        properties[3] = hex"0100000000000004";
        // token uniqueness
//        properties[4] = hex"0100000000000014e821d1b50945ff736992d0af793684dd53ac7fa7000000000000000000000000";

        values = new bytes[](4);
        values[0] = hex"007b0000000000000000";
        values[1] = hex"455552";
        values[2] = hex"000000005c9ca876";
        // version
        values[3] = hex"563928f23599499286e138d185d49af9d2d69b7d291499124ddbecf95533acc8";
        // token uniqueness
//        values[4] = hex"fc03d8fc2094952d153396f1904513850b4f76fcfeaef9c44dcb6d7de1921674";

        salts = new bytes32[](4);
        salts[0] = 0x3d9f77a675dbc27641b27d8bbf612164774adc814a40d3c1324c5c77b26f9aa2;
        salts[1] = 0xcc8a2c1e741a708995d38288d84515df9cb67a52e015d6e73a9cbb6217f4c476;
        salts[2] = 0x4a706b3d95476cef89beba9dee5cd0b1fa4cdc91296bce089bed4b92263bc9f0;
        // version
        salts[3] = 0xcdce11607a4008de202a3d0aea684f812e0ec6f45c7a8a904b98214d2c042bf4;
        // token uniqueness
//        salts[4] = 0x200d4ab58a902b0f5b860cf04ef19ea3c40113558c2a3858da583ebf76b4fc74;

        proofs = new bytes32[][](4);
        proofs[0] = new bytes32[](7);
        proofs[0][0] = 0xd42948fa37dd912117ac5966b55d4b364005e4dc366e3afb6caf38649dce7d20;
        proofs[0][1] = 0xccaad8761ce1a541483d2fb98d621a9a9c11d7b03d82fdbeb2cefdbb8405916e;
        proofs[0][2] = 0x598e8661d6c2a206e632f12c9031a3b50e02af430b144f71db2bbde83e8da2ec;
        proofs[0][3] = 0x7f8410d0adbc62a9b9933c8cb16a45c0cca73dec62e89b185f22a06073e7b960;
        proofs[0][4] = 0x6a37a214f9f3cb50f0cbdfd4183040781860acf7ccb1a4c8453cf31003fc99e7;
        proofs[0][5] = 0x41337de1d0f1a323f5fcca15144b7a1f37cbb442a053fee73f84f27afbc3d719;
        proofs[0][6] = 0x480d3bf285726b8ecf2199da06f35bb77830e07828e036bf9a8dc8c95129f45e;

        proofs[1] = new bytes32[](7);
        proofs[1][0] = 0x07b97ffc8aaf85fffa15cec19f509f876d26af31a3186af35d4672b05f8a5310;
        proofs[1][1] = 0xccaad8761ce1a541483d2fb98d621a9a9c11d7b03d82fdbeb2cefdbb8405916e;
        proofs[1][2] = 0x598e8661d6c2a206e632f12c9031a3b50e02af430b144f71db2bbde83e8da2ec;
        proofs[1][3] = 0x7f8410d0adbc62a9b9933c8cb16a45c0cca73dec62e89b185f22a06073e7b960;
        proofs[1][4] = 0x6a37a214f9f3cb50f0cbdfd4183040781860acf7ccb1a4c8453cf31003fc99e7;
        proofs[1][5] = 0x41337de1d0f1a323f5fcca15144b7a1f37cbb442a053fee73f84f27afbc3d719;
        proofs[1][6] = 0x480d3bf285726b8ecf2199da06f35bb77830e07828e036bf9a8dc8c95129f45e;

        proofs[2] = new bytes32[](7);
        proofs[2][0] = 0xfb2b62df3ef2783f2e27ebe1a58aeb6a5e0915c4ced901bd85288d6fb144a02c;
        proofs[2][1] = 0x0d2a959865cbb523021c642d37a8c018eba07782357d055a361e4ec769c500e1;
        proofs[2][2] = 0x775dd58168d7b778197f0d5eab357647cd27ab91706b7f5acbc86bb33f84daf9;
        proofs[2][3] = 0x3e76163beecf850fd051fda774d06d2963303721d1eb25fcb56f5dfa6b9f0add;
        proofs[2][4] = 0x17e476077dde0a65139b094cff2c2bde82c2bf38c08299f28643074d117f967a;
        proofs[2][5] = 0x41337de1d0f1a323f5fcca15144b7a1f37cbb442a053fee73f84f27afbc3d719;
        proofs[2][6] = 0x480d3bf285726b8ecf2199da06f35bb77830e07828e036bf9a8dc8c95129f45e;

        // version
        proofs[3] = new bytes32[](7);
        proofs[3][0] = 0x2f57c3d607effeac903b45ece78c569edd2f7a59defa1d806823f61d4495e435;
        proofs[3][1] = 0xc52a2036ab698ae068589bc78c50b7ed48a9d8c86f4c9a7c404980c0226c1099;
        proofs[3][2] = 0x14c175413ed3a91e23fd831235885f7652b78c16e2a86328dd2d8b5adc39cc00;
        proofs[3][3] = 0xdc6ea84837c32ed666d580e7dfb47305e670bd2d5b81c3a1bced33d00a2de749;
        proofs[3][4] = 0xc07430e27007ac41e71f4efa61fbc8141c4220bbe06ae570179aa403d144b1dd;
        proofs[3][5] = 0x428df21c9bae763a91f93587847a596b8e3a77bcbe51c7f218fa3b33906279ec;
        proofs[3][6] = 0x6cff4b5e8568c9d8b612c7dedefbad0553db5da9e9abb4b897a43e28fb43360d;

        // token uniqueness
//        proofs[4] = new bytes32[](7);
//        proofs[4][0] = 0x1729e97cc44f4d0f3930175d1b29a1d0c3d217a244a98be549f72d69bc35f2ef;
//        proofs[4][1] = 0x1d200bb5e4a0935bb392e560398cc4f09ef8a47ce5b60ffb8561f9649b227348;
//        proofs[4][2] = 0x272cf01f0c371697319e95ffade01a221ed60a2fea530d1f252f0966b868157d;
//        proofs[4][3] = 0x8e32d7a9533edbb5fe0af56b58a081adf56fdcc084d7b870ee76099c57f056cc;
//        proofs[4][4] = 0x344c38025b6398676c1014205c69e6c391dd986f1a1e6c9337e7ac1b9daac2f7;
//        proofs[4][5] = 0x428df21c9bae763a91f93587847a596b8e3a77bcbe51c7f218fa3b33906279ec;
//        proofs[4][6] = 0x6cff4b5e8568c9d8b612c7dedefbad0553db5da9e9abb4b897a43e28fb43360d;
    }

    // --- Utils ---
    function hash(bytes32 a, bytes32 b) public pure returns (bytes32) {
        if (a < b) {
            return sha256(abi.encodePacked(a, b));
        } else {
            return sha256(abi.encodePacked(b, a));
        }
    }


    function testMint() public logs_gas {
        // Setting IDFactoryMock to return a valid identity
        identity_factory.file(true);
        // Setting KeyManagerMock to return a valid key
        key_manager.file(true);
        key_manager.file(uint32(0));
        // Setting AnchorMock for newestDocVersion
        anchors.file(root, 0);
//        // Test that the mint method works
        uint tkn = abi.decode(values[3], (uint));
        nft.mint(usr1, tkn, 0, data_root, sigs, signature, properties, values, salts, proofs);
        assertEq(nft.ownerOf(tkn), usr1);
    }
}
