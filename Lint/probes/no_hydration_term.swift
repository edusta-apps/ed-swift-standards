// Probe fixture for the `no_hydration_term` custom rule.
import Foundation

final class SessionStore {
    // TRUE POSITIVE: forbidden term used in the comment below.
    // Restores the cached session (formerly called hydration).
    func restore() {}

    // TRUE POSITIVE: forbidden term used as a bare identifier.
    func hydrate() {}

    // TRUE POSITIVE: forbidden term inside a user-facing string.
    let status = "Hydrating..."

    // FALSE POSITIVE CHECK: "dehydrator" has no word boundary before "hydrat".
    let applianceName = "dehydrator"

    // FALSE POSITIVE CHECK: unrelated word, no match at all.
    func loadCache() {}
}
