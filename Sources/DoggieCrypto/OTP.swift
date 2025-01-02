//
//  OTP.swift
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

public enum OTP {
    
}

extension OTP {
    
    public enum Digits: Int, CaseIterable, Codable {
        
        case six = 6
        
        case seven = 7
        
        case eight = 8
        
    }
}

extension OTP.Digits {
    
    fileprivate var pow: UInt32 {
        switch self {
        case .six: return 1_000_000
        case .seven: return 10_000_000
        case .eight: return 100_000_000
        }
    }
}

extension OTP {
    
    public static func generate<D: MessageAuthenticationCode>(
        digest: D,
        digits: Digits
    ) -> String {
        
        let hmac = Data(digest)
        let truncated = hmac.dropFirst(Int((hmac.last ?? 0x00) & 0x0f)).prefix(4)
        
        var number: UInt32 = truncated.withUnsafeBytes { bytes in
            let a = UInt32(bytes[0]) << 24
            let b = UInt32(bytes[1]) << 16
            let c = UInt32(bytes[2]) << 8
            let d = UInt32(bytes[3])
            return a | b | c | d
        }
        
        number &= 0x7fffffff
        number = number % digits.pow
        
        let result = String(number)
        if result.count == digits.rawValue {
            return result
        }
        
        let prefixedZeros = String(repeatElement("0", count: (digits.rawValue - result.count)))
        return prefixedZeros + result
    }
}

extension OTP {
    
    public static func generate<H: HashFunction>(
        counter: UInt64,
        key: SymmetricKey,
        digits: Digits,
        algorithm: H.Type
    ) -> String {
        
        let digest = withUnsafeBytes(of: counter.bigEndian) { HMAC<H>.authenticationCode(for: $0, using: key) }
        
        return self.generate(digest: digest, digits: digits)
    }
}
