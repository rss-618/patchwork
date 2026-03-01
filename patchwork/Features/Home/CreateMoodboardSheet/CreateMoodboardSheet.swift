import SwiftUI

struct CreateMoodboardSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: CreateMoodboardSheetViewModel
    
    init(_ viewModel: CreateMoodboardSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(String(localized: .title), text: $viewModel.title)
                        .keyboardType(.asciiCapable)
                    TextField(String(localized: .title), text: $viewModel.height)
                        .keyboardType(.numberPad)
                    TextField(String(localized: .title), text: $viewModel.width)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle(.createMoodboard)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    confirmButton
                }
            }
        }

    }
    
    @ViewBuilder
    var cancelButton: some View {
        Button(role: .cancel) {
            dismiss()
        }
    }
    
    @ViewBuilder
    var confirmButton: some View {
        Button(role: .confirm) {
            Task {
                await viewModel.createMoodboard()
            }
        }
    }
    
}
