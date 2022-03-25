//
//  DigestTest.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2022 Susan Cheng. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import DoggieCrypto
import XCTest

class DigestTest: XCTestCase {
    
    func testDigest() {
        
        let result = md5("hello, world".data(using: .utf8)!)
        
        XCTAssertEqual(result.hexString, "e4d7f1b4ed2e42d15898f4b27b019da4")
    }
    
    func testScrypt() throws {
        
        let scrypt = Scrypt(log2n: 14, blockSize: 8, parallel: 1, keySize: 64)
        
        let result = try scrypt.hash("hello", salt: "abcd")
        
        XCTAssertEqual(result.withUnsafeBytes(_bytes_to_hex), "ebd9ccbdb1c070ad6d38bace52a2611c1dd006b2b0974ff8667ca592c319535943d66c1caf8cd66015c5e90e81423c82c87632a543b1fd79082800a8944b81db")
    }
}
