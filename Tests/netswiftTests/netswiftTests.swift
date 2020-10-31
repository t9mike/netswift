import XCTest
@testable import netswift

final class netswiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(netswift().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
