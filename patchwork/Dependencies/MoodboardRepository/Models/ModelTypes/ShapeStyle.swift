import Foundation

struct ShapeStyle: Codable, Hashable, Sendable, Equatable {
    var fillColorHex: String
    var strokeColorHex: String
    var strokeWidth: Double
    var cornerRadius: Double?
}
