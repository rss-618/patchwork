import Foundation

enum ShapeKind: String, Codable, CaseIterable, Sendable {
    case rectangle
    case roundedRectangle
    case ellipse
    case capsule
    case line
}
