import Foundation

enum Page: Hashable {
    case moodboard(MoodboardViewModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .moodboard(let viewModel):
            hasher.combine(viewModel.id)
        }
    }
    
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
