import SwiftUI

struct MainCoordinator: View {
    @Bindable var viewModel: MainCoordinatorViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.stack) {
            Home(viewModel: viewModel.homeViewModel)
                .navigationDestination(for: Page.self) { page in
                    switch page {
                    case .moodboard(let viewModel):
                        Moodboard(viewModel: viewModel)
                    }
                }
        }
    }
    
}
