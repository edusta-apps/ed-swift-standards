// Probe fixture for the `viewmodel_main_actor` custom rule.

// TRUE POSITIVE: bare final class ViewModel, no @MainActor at all.
final class BadViewModel: ObservableObject {}

// FALSE POSITIVE CHECK: @MainActor on the line above.
@MainActor
final class GoodViewModel: ObservableObject {}

// FALSE POSITIVE CHECK: @MainActor on the same line.
@MainActor final class AlsoGoodViewModel: ObservableObject {}

// TRUE POSITIVE: some other decorator, not @MainActor.
@available(iOS 26, *)
final class StillBadViewModel: ObservableObject {}
