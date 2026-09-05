// Probe fixture for the `service_protocol_sendable` custom rule.

// TRUE POSITIVE: no "...Protocol" suffix, no Sendable.
protocol BackendTokensProviding {
    func backendTokens() async throws -> String
}

// FALSE POSITIVE CHECK: already Sendable.
protocol HeadersProviding: Sendable {
    func standardHeaders() -> [String: String]
}

// TRUE POSITIVE: classic *ServiceProtocol without Sendable.
protocol FooServiceProtocol {
    func doThing()
}
