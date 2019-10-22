import XCTest
@testable import SwiftIB

final class SwiftIBTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftIB().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
