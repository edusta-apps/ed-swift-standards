// Probe fixture for the `service_protocol_isolation` custom rule.

// TRUE POSITIVE: no "...Protocol" suffix, no Sendable, no @MainActor.
protocol BackendTokensProviding {
    func backendTokens() async throws -> String
}

// FALSE POSITIVE CHECK: already Sendable.
protocol HeadersProviding: Sendable {
    func standardHeaders() -> [String: String]
}

// TRUE POSITIVE: classic *ServiceProtocol without Sendable, without @MainActor.
protocol FooServiceProtocol {
    func doThing()
}

// FALSE POSITIVE CHECK: @MainActor on the same line.
@MainActor protocol QuuxService: AnyObject {
    func doQuux()
}

// FALSE POSITIVE CHECK: @MainActor on the line above.
@MainActor
protocol QuxClientProtocol {
    func doQux()
}

// FALSE POSITIVE CHECK: @MainActor with a same-line access modifier.
@MainActor public protocol NetworkStatusMonitoring: AnyObject {
    func startMonitoring()
}

// TRUE POSITIVE: no attribute, no Sendable.
protocol PlainProvider: AnyObject {
    func provide()
}
