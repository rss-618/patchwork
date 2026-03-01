import CoreData
import SwiftUI

@main
struct patchworkApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainCoordinator(viewModel: LiveCoordinator.shared.mainCoordinator)
        }
    }
    
}
