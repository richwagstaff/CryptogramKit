import Foundation
import PuzzlestarAppUI
import SwiftUI

public struct CryptogramInstructions: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Card.whatIsACryptogram()

                Divider()

                Card.digitsReferToLetters()

                Divider()

                Card.lives()

                Divider()

                Card.useLogic()

                Divider()

                Card.goodLuck()
            }
            .padding()
            .padding(.top, 48)
            .padding(.bottom, 32)
        }
    }
}

extension Card {
    static func whatIsACryptogram() -> Card {
        Card(
            title: "What Is A Cryptogram?",
            text: [
                "Cryptograms are short pieces of text that have been converted into numbers.",
                "For example, the number 1 might represent ‘T’, and 2 might stand for ‘Y’.",
                "The challenge is to decode the numbers back into letters to reveal the phrase."
            ]
        )
    }

    static func lives() -> Card {
        Card(
            image: Image(systemName: "heart.fill"),
            title: "Lives",
            text: [
                "You have four lives to complete the cryptogram.",
                "Each incorrect guess will lose you a life.",
                "Should you lose all of your lives, the game will end and we'll graciously reveal the answer."
            ]
        )
    }

    static func digitsReferToLetters() -> CryptogramFeatureCard {
        CryptogramFeatureCard(
            title: "Digits Refer To Letters",
            text: ["Each digit in the cryptogram refers to a letter.", "For example, in the cryptogram above E is 14 and U is 21."],
            cryptogramManager: CryptogramViewManager(
                phrase: "Love is all you need", revealed: ["L", "O", "V", "A", "I", "N", "S", "Y", "D"], cipherMap: Cipher.cipherMap1
            )
        )
    }

    static func useLogic() -> CryptogramFeatureCard {
        CryptogramFeatureCard(
            title: "Use Logic",
            text: ["Use logic to determine which letters correspond to which digits.", "For example, single letter words are likely to be A or I."],
            cryptogramManager: CryptogramViewManager(
                phrase: "I think, therefore, I am", revealed: ["C", "H", "R", "E", "N", "T", "O", "C", "K", "A", "M", "F"], cipherMap: Cipher.cipherMap2
            )
        )
    }

    static func goodLuck() -> Card {
        Card(
            title: "Good Luck!",
            text: [
                "Go forth, code breaker, and crack the secret message!"
            ]
        )
    }
}

#Preview {
    CryptogramInstructions()
}
