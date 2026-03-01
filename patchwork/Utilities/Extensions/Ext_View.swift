import SwiftUI

extension View {
    
    func loadingOverlay<Overlay: View>(
        _ isLoading: Bool,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Overlay
    ) -> some View {
        self
            .disabled(isLoading)
            .overlay(alignment: alignment) {
                if isLoading {
                    content()
                }
            }
    }
    
}
