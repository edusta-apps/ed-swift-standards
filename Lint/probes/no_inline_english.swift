// Probe fixture for the `no_inline_english` custom rule.
import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        VStack {
            // TRUE POSITIVE: inline English sentence in Text.
            Text("Welcome to Havira")

            // FALSE POSITIVE CHECK: single-word string, no space, not a sentence.
            Text("OK")

            // FALSE POSITIVE CHECK: catalog-driven string, not an inline literal.
            Text(String(localized: "welcome.title"))
        }
    }
}
