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

    // FALSE POSITIVE CHECK: token-based font size, not a numeric literal.
    var tokenFont: some View {
        Text("z").font(.system(size: EDTheme.IconSize.large))
    }

    // FALSE POSITIVE CHECK: computed font size from a variable.
    var computedFont: some View {
        Text("z").font(.system(size: fontSize, weight: .bold, design: .rounded))
    }

    // FALSE POSITIVE CHECK: computed font size from an expression.
    var scaledFont: some View {
        Text("z").font(.system(size: size * 0.45))
    }

    // FALSE POSITIVE CHECK: token-based padding, no raw digit right after the paren.
    var tokenPadding: some View {
        Text("z").padding(theme.spacing.md)
    }

    // TRUE POSITIVE: raw font-size literal with extra arguments.
    var literalFontWithArgs: some View {
        Text("z").font(.system(size: 11, weight: .bold, design: .monospaced))
    }

    // TRUE POSITIVE: raw padding literal with whitespace before the digit.
    var literalPaddingWithSpace: some View {
        Text("z").padding( 3)
    }
}
