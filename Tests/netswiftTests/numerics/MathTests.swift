//
//  MathTests.swift
//  netswiftTests
//

import XCTest
@testable import netswift

final class MathTests: XCTestCase {

    func testRoundToEvenUsesRetainedDigitParity() {
        XCTAssertEqual(Math.Round(1.25, 1), 1.2, accuracy: 0.000_000_001)
        XCTAssertEqual(Math.Round(1.35, 1), 1.4, accuracy: 0.000_000_001)
        XCTAssertEqual(Math.Round(2.25, 1), 2.2, accuracy: 0.000_000_001)
        XCTAssertEqual(Math.Round(2.35, 1), 2.4, accuracy: 0.000_000_001)
        XCTAssertEqual(Math.Round(-1.25, 1), -1.2, accuracy: 0.000_000_001)
    }

    func testRoundToEvenHandlesNonMidpointsNormally() {
        XCTAssertEqual(Math.Round(2.26, 1), 2.3, accuracy: 0.000_000_001)
        XCTAssertEqual(Math.Round(-2.26, 1), -2.3, accuracy: 0.000_000_001)
    }

    func testRoundAwayFromZeroUsesSwiftEquivalent() {
        XCTAssertEqual(
            Math.Round(1.25, 1, .AwayFromZero),
            1.3,
            accuracy: 0.000_000_001)
        XCTAssertEqual(
            Math.Round(-1.25, 1, .AwayFromZero),
            -1.3,
            accuracy: 0.000_000_001)
    }
}
