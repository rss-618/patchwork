import CoreData
import SwiftUI

struct Home: View {
    
    // TODO: Include maybe poll based updates (pull if possible), and refreshable style ui (need to try some different things out)
    @Bindable var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch viewModel.loadingStage {
            case .idle, .loading:
                ProgressView()
                    .controlSize(.large)
            case .loaded:
                moodboardList(viewModel.moodboardSummaries)
            case .error:
                RetryView {
                    Task {
                        await viewModel.loadMoodboardSummaries()
                    }
                }
            }
        }
        .navigationTitle(.home)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                addButton
            }
        }
        .task {
            await viewModel.loadMoodboardSummaries()
        }
        .sheet(item: $viewModel.createMoodboardSheet) {
            viewModel.onCreateMoodboardDismiss()
        } content: {
            CreateMoodboardSheet($0)
                .presentationDetents([.medium])
        }
    }
    
    func moodboardList(_ moodboards: [MoodboardSummary]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(moodboards) { moodboard in
                    Button(moodboard.title) {
                        Task {
                            await viewModel.selectMoodboard(id: moodboard.id)
                        }
                    }
                    .buttonSizing(.flexible)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .loadingOverlay(moodboard.id == viewModel.fetchingMoodboard) {
                        ProgressView()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .refreshable {
            Task {
                await viewModel.loadMoodboardSummaries()
            }
        }
    }
    
    var addButton: some View {
        Button(.add, systemImage: "plus") {
            viewModel.addButtonTapped()
        }
        .background(.ultraThinMaterial)
    }
}
