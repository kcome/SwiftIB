import XCTest
@testable import SwiftIB

final class SwiftIBTests: XCTestCase {
    func testTickType() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftIB.TickType.getField(99), "unknown")
    }

    static var allTests = [
        ("testTickType", testTickType),
    ]
}
