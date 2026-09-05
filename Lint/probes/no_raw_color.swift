// Probe fixture for the `no_raw_color` custom rule.
import SwiftUI

struct SomeView {
    // TRUE POSITIVE: raw color literal outside the theme module.
    let a = Color.red

    // FALSE POSITIVE CHECK: .clear is a structural spacer value, not a theme decision.
    let b = Color.clear
}
