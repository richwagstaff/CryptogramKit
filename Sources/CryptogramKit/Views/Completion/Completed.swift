import SwiftUI

public struct Completed: View {
    public var title: String
    public var subtitle: String
    public var time: String?
    public var phrase: String
    public var author: String
    public var source: String?
    public var buttonTitle: String = "Return to Home"
    public var buttonAction: () -> Void

    public var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.body)
            }

            if let time = time {
                Text(time)
                    .font(.system(size: 30, weight: .regular))
                    .multilineTextAlignment(.center)
            }

            VStack {
                Text(phrase)
                    .font(.body)
                    .multilineTextAlignment(.center)
                Text(author)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                if let source = source {
                    Text(source)
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                }
            }

            Button(action: buttonAction, label: {
                Text(buttonTitle)
                    .multilineTextAlignment(.center)
            })
        }
    }
}

#Preview {
    Completed(
        title: "Puzzle Completed!",
        subtitle: "Puzzle Title",
        time: "02:38",
        phrase: "How hard can it be?",
        author: "Rich",
        source: "My head",
        buttonTitle: "Button Title",
        buttonAction: {}
    )
}
