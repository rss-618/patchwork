import SwiftUI

struct RetryView: View {
    let completion: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text(.generalErrorTitle)
                .font(.headline)
            Text(.generalErrorDescription)
                .font(.body)
            
            Button(.retry, action: completion)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background {
                    Capsule()
                        .fill(.ultraThinMaterial)
                }
        }
    }
}
