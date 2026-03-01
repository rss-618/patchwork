import Foundation

struct ItemTransform: Codable, Hashable, Sendable, Equatable {
    var centerX: Double
    var centerY: Double
    var width: Double
    var height: Double
    var rotationRadians: Double
}
