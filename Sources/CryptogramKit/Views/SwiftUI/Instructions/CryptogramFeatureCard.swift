import PuzzlestarAppUI
import SwiftUI

public struct CryptogramFeatureCard: View {
    public var title: String
    public var text: [String]
    public var cryptogramManager: CryptogramViewManager
    public var titleFont: Font = .title
    public var bodyFont: Font = .body

    public var body: some View {
        FeatureCard(
            title: title,
            text: text
        ) {
            Group {
                CryptogramViewRepresentable(manager: cryptogramManager)
                    .padding(.top, 12)
                    .padding(.bottom, 12)
            }
            .background(Color.gray.opacity(0.12))
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    CryptogramFeatureCard(
        title: "Digits Refer To Letters",
        text: ["a cryptogram blah blah", "And some more"],
        cryptogramManager: CryptogramViewManager(
            phrase: "Love is all you need", revealed: ["A", "I"], cipherMap: Cipher.generateNumberCipherMap()
        )
    ).padding()
}
