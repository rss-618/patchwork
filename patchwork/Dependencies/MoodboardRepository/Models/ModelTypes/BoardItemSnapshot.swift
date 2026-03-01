import Foundation

enum BoardItemContent: Sendable, Equatable {
    case image(
        localPath: String,
        opacity: Double,
        cropX: Double?,
        cropY: Double?,
        cropWidth: Double?,
        cropHeight: Double?,
        assetIdentifier: String?
    )
    case text(text: String, style: TextStyle)
    case shape(kind: ShapeKind, style: ShapeStyle)
}

struct BoardItemSnapshot: Identifiable, Sendable, Equatable {
    let id: UUID
    let zIndex: Double
    let transform: ItemTransform
    let createdAt: Date
    let updatedAt: Date
    let content: BoardItemContent
}
