// Probe fixture for the `no_default_service_instance` custom rule's Tests exclusion.
// Lives under Tests/ so this file's path satisfies the rule's `excluded: ".*Tests.*"`
// scope — the pattern below would fire in production code but must be silent here.
final class FooTests {
    // FALSE POSITIVE CHECK (path-scoped): a `makeSUT`-style test factory
    // defaulting a protocol parameter to a live instance is the standard
    // Swift Testing idiom, not a smell — this exact shape fires
    // `no_default_service_instance` in production.
    func makeSUT(analytics: AnalyticsServiceProtocol = LiveAnalyticsService()) -> Foo {
        Foo(analytics: analytics)
    }
}
