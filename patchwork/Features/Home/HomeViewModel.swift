import Combine
import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    // This manual injection stuff is really gross feeling after coming from TCA
    // TODO: look into making my own DI macro lib
    private let coordinator: any Coordinator
    private let moodboardRepository: any MoodboardRepository
    
    var errorCreatingMoodboard: Bool = false
    var errorFetchingMoodboard: Bool = false
    var createMoodboardSheet: CreateMoodboardSheetViewModel?
    
    private(set) var moodboardSummaries: [MoodboardSummary] = .init()
    private(set) var loadingStage: LoadingStage = .idle
    private(set) var fetchingMoodboard: UUID?
    private var createdMoodboard: MoodboardDetail? = nil

    init(
        moodboardRepository: (any MoodboardRepository)? = nil,
        coordinator: (any Coordinator)? = nil
    ) {
        self.moodboardRepository = moodboardRepository ?? .live
        self.coordinator = coordinator ?? .live
    }
    
    enum LoadingStage: Equatable {
        case idle, loading, loaded, error
    }

    func loadMoodboardSummaries() async {
        guard loadingStage != .loading else { return }
        loadingStage = .loading
        do {
            moodboardSummaries = try await moodboardRepository.fetchMoodboardSummaries()
            loadingStage = .loaded
        } catch {
            loadingStage = .error
        }
    }

    func selectMoodboard(id: UUID) async {
        guard fetchingMoodboard == nil else { return }
        fetchingMoodboard = id
        defer { fetchingMoodboard = nil }
        guard let moodboard = try? await moodboardRepository.fetchMoodboard(id: id) else {
            errorCreatingMoodboard = true
            return
        }
        coordinator.navigate(to: .moodboard(.init(moodboard: moodboard)))
    }
    
    func addButtonTapped() {
        createMoodboardSheet = .init(
            moodboardRepository: moodboardRepository,
            onCreation: { moodboard in
                self.createdMoodboard = moodboard
                self.createMoodboardSheet = nil
            }
        )
    }
    
    func onCreateMoodboardDismiss() {
        guard let createdMoodboard else {
            return
        }
        self.createdMoodboard = nil
        coordinator.navigate(to: .moodboard(.init(moodboard: createdMoodboard)))
    }
    
}
