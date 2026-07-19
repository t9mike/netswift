import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(netswiftTests.allTests),
        testCase(MathTests.allTests),
    ]
}

extension MathTests {
    static let allTests = [
        ("testRoundToEvenUsesRetainedDigitParity",
         testRoundToEvenUsesRetainedDigitParity),
        ("testRoundToEvenHandlesNonMidpointsNormally",
         testRoundToEvenHandlesNonMidpointsNormally),
        ("testRoundAwayFromZeroUsesSwiftEquivalent",
         testRoundAwayFromZeroUsesSwiftEquivalent),
    ]
}
#endif
