// Probe fixture for the `no_memory_slug_comment` custom rule.
final class Foo {
    // TRUE POSITIVE: references an internal note-slug.
    // see project_alpha_beta.md
    var a = 1

    // TRUE POSITIVE: "strong foundation" narration.
    // this is a strong-foundation for the app
    var b = 2

    // FALSE POSITIVE CHECK: an ordinary comment with no slug reference.
    // increments the counter by one
    var c = 3
}
