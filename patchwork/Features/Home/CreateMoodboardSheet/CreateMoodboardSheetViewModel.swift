import Observation
import SwiftUI

@MainActor
@Observable
final class CreateMoodboardSheetViewModel: Identifiable {
    let id: UUID
    
    private let moodboardRepository: any MoodboardRepository
    private let onCreation: (MoodboardDetail) -> Void
    
    var title: String = ""
    var width: String = "1600"
    var height: String = "900"
    
    var stage: Stage = .idle

    init(
        id: UUID = UUID(),
        moodboardRepository: any MoodboardRepository,
        onCreation: @escaping (MoodboardDetail) -> Void,
    ) {
        self.id = id
        self.moodboardRepository = moodboardRepository
        self.onCreation = onCreation
    }
    
    enum Stage: Equatable {
        case idle, creating, created, error(CreateError)
    }
    
    enum CreateError: Error {
        case missingTitle
        case invalidHeight
        case invalidWidth
        case technicalError
    }
    
    func createMoodboard() async {
        guard stage != .creating else { return }
        
        guard !title.isEmpty else {
            stage = .error(.missingTitle)
            return
        }
        
        guard let height = Double(height) else {
            stage = .error(.invalidHeight)
            return
        }
        
        guard let width = Double(width) else {
            stage = .error(.invalidWidth)
            return
        }
        
        stage = .creating
        do {
            let moodboard = try await moodboardRepository.createMoodboard(
                title: title,
                canvasWidth: width,
                canvasHeight: height
            )
            stage = .created
            onCreation(moodboard)
        } catch {
            stage = .error(.technicalError)
        }
    }
}
