//
//  Scrypt.swift
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

public struct Scrypt {
    
    public var log2n: UInt64
    
    public var r: UInt64
    
    public var p: UInt64
    
    public var keySize: Int
    
    public init(
        log2n: UInt64 = 14,
        r: UInt64 = 8,
        p: UInt64 = 1,
        keySize: Int = 64
    ) {
        self.log2n = log2n
        self.r = r
        self.p = p
        self.keySize = keySize
    }
}

extension Scrypt {
    
    public func hash(_ plaintext: String, salt: UnsafeBufferPointer<UInt8>) throws -> [UInt8] {
        
        return try Array(unsafeUninitializedCapacity: keySize) { buffer, initializedCount in
            
            let retval = CCryptoBoringSSL_EVP_PBE_scrypt(
                plaintext, plaintext.utf8.count,
                salt.baseAddress, salt.count,
                1 << log2n, r, p, 0,
                buffer.baseAddress, keySize
            )
            
            guard retval == 1 else { throw CryptoKitError.internalBoringSSLError() }
            
            initializedCount = keySize
        }
    }
}

extension Scrypt {
    
    public func hash(_ plaintext: String, salt: String) throws -> [UInt8] {
        var salt = salt
        return try salt.withUTF8 { try self.hash(plaintext, salt: $0) }
    }
    
    public func hash(_ plaintext: String, salt: [UInt8]) throws -> [UInt8] {
        return try salt.withUnsafeBufferPointer { try self.hash(plaintext, salt: $0) }
    }
}
