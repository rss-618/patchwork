import SwiftUI

struct Moodboard: View {
    
    @Bindable var viewModel: MoodboardViewModel
    
    var body: some View {
        VStack {
            Text(verbatim: "TODO")
        }
        .navigationTitle(viewModel.moodboard.title)
    }
}
