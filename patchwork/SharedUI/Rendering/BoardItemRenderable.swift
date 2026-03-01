import SwiftUI

protocol BoardItemRenderable {
    var transform: ItemTransform { get }
    var zIndex: Double { get }
}

extension BoardItemSnapshot: BoardItemRenderable {}

struct BoardSpaceProjector: Sendable {
    let canvasWidth: Double
    let canvasHeight: Double
    let containerWidth: Double
    let containerHeight: Double

    var scale: Double {
        min(containerWidth / canvasWidth, containerHeight / canvasHeight)
    }

    var horizontalInset: Double {
        (containerWidth - (canvasWidth * scale)) / 2
    }

    var verticalInset: Double {
        (containerHeight - (canvasHeight * scale)) / 2
    }

    func position(for transform: ItemTransform) -> CGPoint {
        CGPoint(
            x: horizontalInset + (transform.centerX * scale),
            y: verticalInset + (transform.centerY * scale)
        )
    }

    func size(for transform: ItemTransform) -> CGSize {
        CGSize(
            width: transform.width * scale,
            height: transform.height * scale
        )
    }

    func rotation(for transform: ItemTransform) -> Angle {
        .radians(transform.rotationRadians)
    }
}
