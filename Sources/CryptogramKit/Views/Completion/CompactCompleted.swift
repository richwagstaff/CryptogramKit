import SwiftUI

public struct CompactCompleted: View {
    @ObservedObject public var viewModel: CompactCompletedViewModel
    public var shareAction: () -> Void

    public var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.title)
                .font(viewModel.styles.titleFont)
                .multilineTextAlignment(.center)

            if let subtitle = viewModel.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(viewModel.styles.subtitleFont)
            }

            if let message = viewModel.message {
                Text(message)
                    .font(viewModel.styles.messageFont)
                    .multilineTextAlignment(.center)
            }

            Button(action: shareAction) {
                Text("Share")
                    .font(viewModel.styles.messageFont)
            }
        }
    }
}

#Preview {
    CompactCompleted(
        viewModel: CompactCompletedViewModel(
            title: "Better Luck Next Time!",
            subtitle: "⏱️ 02:38",
            message: nil
        ),
        shareAction: {}
    )
}
