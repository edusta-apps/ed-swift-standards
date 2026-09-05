// Probe fixture for the `no_default_service_instance` custom rule.
final class Foo {
    // TRUE POSITIVE: protocol-typed parameter defaulted to a concrete live instance.
    init(analytics: AnalyticsServiceProtocol = LiveAnalyticsService()) {}

    // FALSE POSITIVE CHECK: required, no default value at all.
    init(cache: any CacheRepositoryProtocol) {}

    // FALSE POSITIVE CHECK: type does not end in Service/RepositoryProtocol.
    init(cache: CacheProtocol = MemoryCache()) {}
}
