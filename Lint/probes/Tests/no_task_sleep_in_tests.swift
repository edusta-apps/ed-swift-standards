// Probe fixture for the `no_task_sleep_in_tests` custom rule.
// Lives under Tests/ so this file's path satisfies the rule's `included: ".*Tests.*"` scope.
import Testing

@Test func waitsOnSignal() async throws {
    // TRUE POSITIVE: sleeping instead of awaiting the real signal.
    try await Task.sleep(nanoseconds: 1_000_000_000)

    // FALSE POSITIVE CHECK: a different clock API entirely.
    await mockClock.advance(by: .seconds(1))
}
