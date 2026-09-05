// Probe fixture for the `no_raw_spacing_font` custom rule.
import SwiftUI

struct SomeView: View {
    var body: some View {
        // TRUE POSITIVE: raw padding literal.
        Text("x")
            .padding(16)
            // TRUE POSITIVE: raw font-size literal.
            .font(.system(size: 14))
    }

    // FALSE POSITIVE CHECK: token-based spacing, no raw digit right after the paren.
    var themed: some View {
        Text("y").padding(.horizontal, 8)
    }
}
