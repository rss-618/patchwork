import Observation
import SwiftUI

@MainActor
@Observable
final class HomeViewModel {
    
    let boardRepository: any BoardRepository
    
    init(boardRepository: any BoardRepository) {
        self.boardRepository = boardRepository
    }

    init() {
        self.boardRepository = LiveBoardRepository()
    }
}
