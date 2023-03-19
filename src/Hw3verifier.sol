// SPDX-License-Identifier: MIT
//
// This is the exported verifier during my ZoKrates pre-image hash tutorial
//
// verifyTx requires this input:
/*
 [["0x2fc7c1c857af8edc07e078c8767dec0934fd57d246a037d539b5cf40a6a1cf18","0x217e26ea80810708833e477b28ca7daca2feabe97793333bd8a6c3c15936a2ad"],[["0x0e93b47c08e1f0f3a41d758b46afc655e8000575b7113d73795b46d87ccce100","0x1c4616c741e4ce40966b74290f5199b6237f91b5f27ce520f11f882d40496ca7"],["0x05c4a97bac5f0bab3d697f1c1a4b40eccf5f462616df16d6abaafd230addd587","0x0a7f82f45fab2e0d6c011ece7bf19d3b86a7c97a72515dba985a447deedfaab8"]],
 ["0x11979cb5a8c5ea09c666ca6287c5b23325cb3f9a01dc74e097b6e10fdd8ab774","0x2e0aa992b28186fceb1ccb1adf38c9e6b09282da0740a81c03c4af276d6076ec"]],["0x00000000000000000000000000000000c6481e22c5ff4164af680b8cfaa5e8ed","0x000000000000000000000000000000003120eeff89c4f307c4a6faaae059ce10"]
*/
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.8.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.alpha = Pairing.G1Point(uint256(0x096889b6ea04b8dc0835c469c789efafeea75909567bfcde46e4986222282eab), uint256(0x06135ee10322a20ff226fa6e2560853dfee9c925b2e723d75302ae184920937a));
        vk.beta = Pairing.G2Point([uint256(0x21dabe6851c9c71ce8c2205f440437e68a120c839c6394b5a065175c43bdf44a), uint256(0x17f04b947c20b6c47460dd1d67e20a7daa37be5daa3123ffc5cb7a3dda4d141c)], [uint256(0x1a109750c613ef6069d5682bbdc100b13c812f20bc1df5675bcefeb461999918), uint256(0x1c8ed250677c3a213e74ae8baf01eb906ea4390a52c2af5dad3be101076e946b)]);
        vk.gamma = Pairing.G2Point([uint256(0x07900a8f063ef81fb1448f4b628b7f42ecced705fc30ff090b525a547d5ee986), uint256(0x2cfec5dabd114ca6d86e23c20f686fef94a6a21c1d201f7e28145c290f524e31)], [uint256(0x15fb6f9b8165ccceb177550fbba815b7bf08dc74c599fa8f7347daf9563f07f5), uint256(0x27b47e533f59d38c4ffd69065a7235335b3d58e374bd8b2373bc8dd0c02eef22)]);
        vk.delta = Pairing.G2Point([uint256(0x1ecbac5719b40ae26038858995ff8e0d14b15382f4796164ebc1eaffbf56d109), uint256(0x0aa0df68df7303072f2825384ec1aabaa95f155a55bd9cbd1a72b4555c611be3)], [uint256(0x2ae2913389e15b8007d0456df885431151462e023f503898f5ea596aca70e386), uint256(0x18d80870b3cdbbd110e1294dd2b0113a3c0d99aca0aa8c09e752128af670b737)]);
        vk.gamma_abc = new Pairing.G1Point[](3);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x1054afe58f20fc39d863a27f6a0fb042708707b05f667bce6f2c0f0aa92e5bac), uint256(0x113bdcbbea7c17f8c7dfc3d9c7aea2210b5e8b1788a35d4e0d305e5d9e382202));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1170c2456819f81cb8a2e1f3f334a68261c4de4fa2a875dfa1f504711bb125f6), uint256(0x2d04709b84a87433a7848bdaac07d0933a7b2b164b9080b834c826ac6fa6b9c4));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x0c1f5f5c8622c20eeb4e08eb2b2b28da5b1b2fe7007745a02cd976eb09982f23), uint256(0x24cab9cbae586241b658ab7c42348674faf65ec762d98ac0216b7933e9947f4a));
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[2] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](2);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}