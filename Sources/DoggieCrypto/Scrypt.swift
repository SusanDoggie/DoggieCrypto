//
//  Scrypt.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2025 Susan Cheng. All rights reserved.
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

import libscrypt

public struct Scrypt {
    
    public var log2n: UInt64
    
    public var blockSize: UInt32
    
    public var parallel: UInt32
    
    public var keySize: Int
    
    public init(
        log2n: UInt64 = 14,
        blockSize: UInt32 = 8,
        parallel: UInt32 = 1,
        keySize: Int = 64
    ) {
        self.log2n = log2n
        self.blockSize = blockSize
        self.parallel = parallel
        self.keySize = keySize
    }
}

extension Scrypt {
    
    private func _hash(_ plaintext: String, salt: UnsafeRawBufferPointer) throws -> [UInt8] {
        
        return try Array(unsafeUninitializedCapacity: keySize) { buffer, initializedCount in
            
            let retval = libscrypt_scrypt(
                plaintext, plaintext.utf8.count,
                salt.baseAddress!.assumingMemoryBound(to: UInt8.self), salt.count,
                1 << log2n, blockSize, parallel,
                buffer.baseAddress, keySize
            )
            
            guard retval == 0 else { throw CryptoKitError.underlyingCoreCryptoError(error: errno) }
            
            initializedCount = keySize
        }
    }
}

extension Scrypt {
    
    public func hash(_ plaintext: String, salt: String) throws -> [UInt8] {
        var salt = salt
        return try salt.withUTF8 { try self._hash(plaintext, salt: UnsafeRawBufferPointer($0)) }
    }
    
    public func hash<Bytes: ContiguousBytes>(_ plaintext: String, salt: Bytes) throws -> [UInt8] {
        return try salt.withUnsafeBytes { try self._hash(plaintext, salt: $0) }
    }
}
