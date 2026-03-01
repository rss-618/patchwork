import Foundation

protocol MoodboardRepository: Actor {
    func fetchMoodboardSummaries() throws -> [MoodboardSummary]
    func fetchMoodboard(id: UUID) throws -> MoodboardDetail?

    @discardableResult
    func createMoodboard(
        title: String,
        canvasWidth: Double,
        canvasHeight: Double
    ) throws -> MoodboardDetail

    func saveChanges() throws
}

extension MoodboardRepository where Self == LiveMoodboardRepository {
    @MainActor
    static var live: Self {
        LiveMoodboardRepository.live()
    }
}
