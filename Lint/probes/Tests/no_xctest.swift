// Probe fixture for the `no_xctest` custom rule.
// Lives under Tests/ so this file's path satisfies the rule's `included: ".*Tests.*"` scope.

// TRUE POSITIVE: XCTest import.
import XCTest

func check() {
    // TRUE POSITIVE: XCTAssert-family call.
    XCTAssertEqual(1, 1)

    // FALSE POSITIVE CHECK: XCTFail is not matched by the XCTAssert\w*( pattern.
    XCTFail("boom")
}
