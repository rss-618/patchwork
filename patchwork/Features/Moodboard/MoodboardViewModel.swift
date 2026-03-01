import SwiftUI
import Observation

@MainActor
@Observable
final class MoodboardViewModel: Identifiable {
    
    let id: UUID
    let moodboard: MoodboardDetail
    var canvasItems: [BoardItemSnapshot]
    var isAddCardSheetPresented: Bool = false
    var isBoardInfoPresented: Bool = false
    
    init(
        id: UUID = .init(),
        moodboard: MoodboardDetail
    ) {
        self.id = id
        self.moodboard = moodboard
        self.canvasItems = moodboard.items.sorted { $0.zIndex < $1.zIndex }
    }

    enum CardOption: String, CaseIterable, Identifiable {
        case text
        case shape
        case image

        var id: String { rawValue }

        var title: String {
            switch self {
            case .text:
                "Text"
            case .shape:
                "Shape"
            case .image:
                "Image"
            }
        }

        var subtitle: String {
            switch self {
            case .text:
                "Add a text card"
            case .shape:
                "Add a shape card"
            case .image:
                "Add an image placeholder"
            }
        }

        var systemImage: String {
            switch self {
            case .text:
                "textformat"
            case .shape:
                "square.on.circle"
            case .image:
                "photo"
            }
        }
    }

    func addCardTapped() {
        isAddCardSheetPresented = true
    }

    func boardInfoTapped() {
        isBoardInfoPresented = true
    }

    func addCard(_ option: CardOption) {
        let now = Date()
        let center = ItemTransform(
            centerX: moodboard.canvasWidth / 2,
            centerY: moodboard.canvasHeight / 2,
            width: defaultWidth(for: option),
            height: defaultHeight(for: option),
            rotationRadians: 0
        )
        let item = BoardItemSnapshot(
            id: UUID(),
            zIndex: nextZIndex,
            transform: center,
            createdAt: now,
            updatedAt: now,
            content: defaultContent(for: option)
        )
        canvasItems.append(item)
        canvasItems.sort { $0.zIndex < $1.zIndex }
        isAddCardSheetPresented = false
    }

    private var nextZIndex: Double {
        (canvasItems.map(\.zIndex).max() ?? 0) + 1
    }

    private func defaultWidth(for option: CardOption) -> Double {
        switch option {
        case .text:
            max(220, moodboard.canvasWidth * 0.24)
        case .shape:
            max(240, moodboard.canvasWidth * 0.2)
        case .image:
            max(260, moodboard.canvasWidth * 0.28)
        }
    }

    private func defaultHeight(for option: CardOption) -> Double {
        switch option {
        case .text:
            100
        case .shape:
            max(180, moodboard.canvasHeight * 0.2)
        case .image:
            max(180, moodboard.canvasHeight * 0.24)
        }
    }

    private func defaultContent(for option: CardOption) -> BoardItemContent {
        switch option {
        case .text:
            .text(
                text: "New text",
                style: TextStyle(
                    fontName: "Helvetica Neue",
                    fontSize: 28,
                    fontWeight: "regular",
                    textColorHex: "#1E1E1E",
                    alignment: .center
                )
            )
        case .shape:
            .shape(
                kind: .roundedRectangle,
                style: ShapeStyle(
                    fillColorHex: "#F7D99A",
                    strokeColorHex: "#CC8C2E",
                    strokeWidth: 3,
                    cornerRadius: 20
                )
            )
        case .image:
            .image(
                localPath: "",
                opacity: 1,
                cropX: nil,
                cropY: nil,
                cropWidth: nil,
                cropHeight: nil,
                assetIdentifier: nil
            )
        }
    }
}
