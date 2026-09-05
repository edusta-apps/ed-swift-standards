// Probe fixture for the `no_completion_handler` custom rule.
final class Fetcher {
    // TRUE POSITIVE: new completion-handler API.
    func fetch(completion: @escaping (Result<Data, Error>) -> Void) {}

    // FALSE POSITIVE CHECK: async/await, no completion handler.
    func fetch() async throws -> Data { Data() }

    // FALSE POSITIVE CHECK: a differently-labeled escaping closure, not "completion:".
    func observe(handler: @escaping () -> Void) {}
}
