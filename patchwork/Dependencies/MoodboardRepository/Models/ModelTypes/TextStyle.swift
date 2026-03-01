import Foundation

struct TextStyle: Codable, Hashable, Sendable, Equatable {
    var fontName: String
    var fontSize: Double
    var fontWeight: String
    var textColorHex: String
    var alignment: TextAlignmentKind
}
