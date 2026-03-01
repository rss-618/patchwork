import Foundation

struct MoodboardSummary: Identifiable, Hashable, Sendable {
    let id: UUID
    let title: String
    let canvasWidth: Double
    let canvasHeight: Double
    let updatedAt: Date
}
