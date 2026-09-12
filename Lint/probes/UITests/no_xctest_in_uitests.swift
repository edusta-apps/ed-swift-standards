// Probe fixture for the `no_xctest` custom rule's UITests exclusion.
// Lives under UITests/ so this file's path satisfies `excluded: ".*UITests.*"`
// even though it also matches `included: ".*Tests.*"` — XCUITest has no Swift
// Testing UI-automation equivalent, so XCTest is the only viable API here.
import XCTest

final class LaunchUITests: XCTestCase {
    func testLaunch() {
        // FALSE POSITIVE CHECK (path-scoped): the only viable API in a
        // UITests target — must not fire here.
        XCTAssertTrue(true)
    }
}
