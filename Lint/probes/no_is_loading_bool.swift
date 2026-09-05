// Probe fixture for the `no_is_loading_bool` custom rule.
import Combine

@MainActor
final class SomeViewModel: ObservableObject {
    // TRUE POSITIVE: scattered isLoading boolean.
    @Published var isLoading: Bool = false

    // TRUE POSITIVE: scattered hasLoaded boolean, with private(set).
    @Published private(set) var hasLoadedMore: Bool = false

    // FALSE POSITIVE CHECK: not a Loading/Loaded state boolean.
    @Published var isEnabled: Bool = true

    // FALSE POSITIVE CHECK: not @Published at all.
    var isLoadingLocal: Bool = false
}
