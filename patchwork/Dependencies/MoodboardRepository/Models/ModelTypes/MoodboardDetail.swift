import Foundation

struct MoodboardDetail: Identifiable, Sendable, Equatable {
    let id: UUID
    let title: String
    let canvasWidth: Double
    let canvasHeight: Double
    let createdAt: Date
    let updatedAt: Date
    let items: [BoardItemSnapshot]
}

extension MoodboardDetail {
    nonisolated init?(_ moodboard: MoodboardModel) {
        guard
            let moodboardID = moodboard.id,
            let title = moodboard.title,
            let createdAt = moodboard.createdAt,
            let updatedAt = moodboard.updatedAt
        else {
            return nil
        }

        let items = moodboard.sortedItems.compactMap { item -> BoardItemSnapshot? in
            guard
                let itemID = item.id,
                let itemCreatedAt = item.createdAt,
                let itemUpdatedAt = item.updatedAt
            else {
                return nil
            }

            let content: BoardItemContent
            switch item {
            case let imageItem as ImageItem:
                guard let localPath = imageItem.imageLocalPath else { return nil }
                content = .image(
                    localPath: localPath,
                    opacity: imageItem.opacity,
                    cropX: imageItem.cropX,
                    cropY: imageItem.cropY,
                    cropWidth: imageItem.cropWidth,
                    cropHeight: imageItem.cropHeight,
                    assetIdentifier: imageItem.assetIdentifier
                )
            case let textItem as TextItem:
                guard let text = textItem.text else { return nil }
                content = .text(text: text, style: textItem.textStyle)
            case let shapeItem as ShapeItem:
                content = .shape(kind: shapeItem.shapeKind, style: shapeItem.shapeStyle)
            default:
                return nil
            }

            return BoardItemSnapshot(
                id: itemID,
                zIndex: item.zIndex,
                transform: item.transform,
                createdAt: itemCreatedAt,
                updatedAt: itemUpdatedAt,
                content: content
            )
        }

        self.init(
            id: moodboardID,
            title: title,
            canvasWidth: moodboard.canvasWidth,
            canvasHeight: moodboard.canvasHeight,
            createdAt: createdAt,
            updatedAt: updatedAt,
            items: items
        )
    }
}
