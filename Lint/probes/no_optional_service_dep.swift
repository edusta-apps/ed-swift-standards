// Probe fixture for the `no_optional_service_dep` custom rule.
final class Foo {
    // FALSE POSITIVE CHECK: plain optional published state, not a service dep default.
    @Published var pendingDownloadManager: DownloadManager? = nil

    // TRUE POSITIVE: defaulted-away-from-required init param, single line.
    init(downloadManager: DownloadManager? = nil) {}

    // TRUE POSITIVE: defaulted-away-from-required init param, multi-line, second param.
    init(
        analyticsClient: AnalyticsClient,
        crashService: CrashService? = nil
    ) {}

    // FALSE POSITIVE CHECK: required, non-optional service dependency.
    init(store: any TokenStoreProtocol) {}
}
