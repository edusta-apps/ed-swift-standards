// Probe fixture for the `no_raw_color` custom rule.
import SwiftUI

struct SomeView {
    // TRUE POSITIVE: raw color literal outside the theme module.
    let a = Color.red

    // FALSE POSITIVE CHECK: .clear is a structural spacer value, not a theme decision.
    let b = Color.clear

    // FALSE POSITIVE CHECK: UIColor is a different API, not a theme decision.
    let c = UIColor.red

    // FALSE POSITIVE CHECK: UIColor(...) is a different API, not a theme decision.
    let d = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
}
