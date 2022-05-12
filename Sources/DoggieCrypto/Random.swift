//
//  Random.swift
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

#if canImport(Security)

import Security

public func secureRandomCopyBytes(_ bytes: UnsafeMutableRawBufferPointer) throws {
    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, bytes.baseAddress!)
    guard status == errSecSuccess else { throw NSError(domain: NSOSStatusErrorDomain, code: Int(status)) }
}

#else

import CCryptoBoringSSL

public func secureRandomCopyBytes(_ bytes: UnsafeMutableRawBufferPointer) throws {
    guard CCryptoBoringSSL_RAND_bytes(bytes.baseAddress!.assumingMemoryBound(to: UInt8.self), bytes.count) == 1 else { throw CryptoKitError.internalBoringSSLError() }
}

#endif

extension Data {
    
    public static func secureRandomBytes(count: Int) throws -> Data {
        var result = Data(count: count)
        try result.withUnsafeMutableBytes(secureRandomCopyBytes)
        return result
    }
}

extension Array where Element == Int8 {
    
    public static func secureRandomBytes(count: Int) throws -> [Int8] {
        
        return try .init(unsafeUninitializedCapacity: count) { bytes, initializedCount in
            try secureRandomCopyBytes(UnsafeMutableRawBufferPointer(bytes))
            initializedCount = count
        }
    }
}

extension Array where Element == UInt8 {
    
    public static func secureRandomBytes(count: Int) throws -> [UInt8] {
        
        return try .init(unsafeUninitializedCapacity: count) { bytes, initializedCount in
            try secureRandomCopyBytes(UnsafeMutableRawBufferPointer(bytes))
            initializedCount = count
        }
    }
}
