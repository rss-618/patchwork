import SwiftUI


@MainActor
final class LiveCoordinator: Coordinator {
    static let shared = LiveCoordinator()

    lazy var mainCoordinator: MainCoordinatorViewModel = .init()

    private init() {}

    func popToRoot() {
        mainCoordinator.popToRoot()
    }

    func navigate(to page: Page) {
        mainCoordinator.navigate(to: page)
    }
}
