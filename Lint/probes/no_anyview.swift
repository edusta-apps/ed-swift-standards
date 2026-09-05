// Probe fixture for the `no_anyview` custom rule.
import SwiftUI

struct ContentWrapper {
    // FALSE POSITIVE CHECK: mentioning AnyView( in a comment must not match.
    func makeContent() -> AnyView {
        // TRUE POSITIVE: AnyView erasure in a shared content closure.
        AnyView(Text("Wrapped"))
    }

    // FALSE POSITIVE CHECK: concrete return type, no AnyView at all.
    func other() -> some View { Text("plain") }
}
