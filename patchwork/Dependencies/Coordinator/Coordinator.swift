import Foundation

@MainActor
protocol Coordinator {
    func popToRoot()
    func navigate(to page: Page)
}

extension Coordinator where Self == LiveCoordinator {
    static var live: LiveCoordinator { .shared }
}

