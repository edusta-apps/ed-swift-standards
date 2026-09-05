// Probe fixture for the `no_a11y_key` custom rule.
final class Foo {
    // TRUE POSITIVE: the abbreviation "a11y" inside a localization key string.
    let key = "button.a11y.close"

    // FALSE POSITIVE CHECK: spelled out, no "a11y" substring.
    let spelledOutKey = "button.accessibility.close"

    // FALSE POSITIVE CHECK: "a11y" only appears in a comment, not a string literal.
    // old key was "close.a11y.label"
    let unrelated = "close.label"
}
