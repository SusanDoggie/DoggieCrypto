//
//  Digest.swift
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

extension Digest {
    
    public var hexString: String {
        self.withUnsafeBytes(bytes_to_hex)
    }
}

public func md5<D: DataProtocol>(_ data: D) -> Insecure.MD5.Digest {
    return Insecure.MD5.hash(data: data)
}

public func sha1<D: DataProtocol>(_ data: D) -> Insecure.SHA1.Digest {
    return Insecure.SHA1.hash(data: data)
}

public func sha256<D: DataProtocol>(_ data: D) -> SHA256.Digest {
    return SHA256.hash(data: data)
}

public func sha384<D: DataProtocol>(_ data: D) -> SHA384.Digest {
    return SHA384.hash(data: data)
}

public func sha512<D: DataProtocol>(_ data: D) -> SHA512.Digest {
    return SHA512.hash(data: data)
}
