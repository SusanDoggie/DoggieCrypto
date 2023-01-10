//
//  safe_compare.swift
//
//  The MIT License
//  Copyright (c) 2015 - 2023 Susan Cheng. All rights reserved.
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

@inlinable
public func safe_compare<LHS: Collection, RHS: Collection>(_ lhs: LHS, _ rhs: RHS) -> Bool where LHS.Element: Equatable, LHS.Element == RHS.Element {
    guard lhs.count == rhs.count else { return false }
    return zip(lhs, rhs).reduce(true) { $0 && $1.0 == $1.1 }
}

@inlinable
func _safe_compare_bytes<LHS: Collection, RHS: Collection>(_ lhs: LHS, _ rhs: RHS) -> Bool where LHS.Element == UInt8, RHS.Element == UInt8 {
    guard lhs.count == rhs.count else { return false }
    return zip(lhs, rhs).reduce(into: 0) { $0 |= $1.0 ^ $1.1 } == 0
}

@inlinable
public func safe_compare_bytes<LHS: ContiguousBytes, RHS: ContiguousBytes>(_ lhs: LHS, _ rhs: RHS) -> Bool {
    return lhs.withUnsafeBytes { lhs in rhs.withUnsafeBytes { rhs in _safe_compare_bytes(lhs, rhs) } }
}
