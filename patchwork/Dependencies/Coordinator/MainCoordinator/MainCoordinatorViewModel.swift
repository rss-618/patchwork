import Observation
import SwiftUI

@MainActor
@Observable
final class MainCoordinatorViewModel {
    @ObservationIgnored
    private(set) var homeViewModel: HomeViewModel = .init()
    
    var stack: [Page] = []
    
    func popToRoot() {
        stack.removeAll()
    }
    
    func navigate(to page: Page) {
        stack.append(page)
    }
}
