// Probe fixture for the `no_optional_service_dep` custom rule's Tests exclusion.
// Lives under Tests/ so this file's path satisfies the rule's `excluded: ".*Tests.*"`
// scope — the pattern below would fire in production code but must be silent here.
final class FooTests {
    // FALSE POSITIVE CHECK (path-scoped): a `makeSUT`-style test factory
    // defaulting a mock dependency is the standard Swift Testing idiom, not
    // a smell — this exact shape fires `no_optional_service_dep` in production.
    func makeSUT(downloadManager: DownloadManager? = nil) -> Foo {
        Foo(downloadManager: downloadManager)
    }
}
