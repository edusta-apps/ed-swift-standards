// Probe fixture for the `no_fileprivate` custom rule.
// FALSE POSITIVE CHECK: fileprivate mentioned only in a comment, never as a keyword.
// We never use fileprivate here; prefer private.
final class Foo {
    // TRUE POSITIVE: actual fileprivate keyword usage.
    fileprivate var secret = 1

    // FALSE POSITIVE CHECK: private is fine.
    private var alsoSecret = 2
}
