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
                "The challenge is to decode the numbers back into letters to reveal the secret message."
            ]
        )
    }

    static func lives() -> Card {
        Card(
            image: Image(systemName: "heart.fill"),
            title: "Lives",
            text: [
                "You can make up to 4 mistakes when solving the cryptogram.",
                "Each incorrect guess will lose you a life.",
                "Should you lose all of your lives, the game will end and we'll reveal the answer."
            ]
        )
    }

    static func digitsReferToLetters() -> CryptogramFeatureCard {
        CryptogramFeatureCard(
            title: "Decoding Numbers to Letters",
            text: [
                "Each number in the cryptogram refers to a letter.",
                "For example, in the cryptogram above, 14 represents \"E\" and 21 represents \"U\".",
                "A number always represents the same letter throughout the cryptogram."

            ],
            cryptogramManager: CryptogramViewManager(
                phrase: "Love is all you need", revealed: ["L", "O", "V", "A", "I", "N", "S", "Y", "D"], cipherMap: Cipher.cipherMap1, lineBreakElement: LineBreakCryptogramCellViewModel()
            )
        )
    }

    static func useLogic() -> CryptogramFeatureCard {
        CryptogramFeatureCard(
            title: "Patterns To Look For",
            text: [
                "When you see a one-letter word, it's almost always going to be an A or an I.",
                "A word with an apostrophe could be one that ends in 's or something like DON'T, CAN'T, WE'D, YOU'VE, WE'LL, THEY'RE, IT'S, etc.",
                "Some of the most common three-letter words include AND, ARE, BUT, CAN, FOR, HAS, HER, HIS, HOW, NOT, ONE, OUR, THE, USE, WAS, WHO, and YOU.",
                "And finally, some of common word endings include -ED, -ING, -LY."
            ],
            cryptogramManager: CryptogramViewManager(
                phrase: "I think, therefore, I am", revealed: ["C", "H", "R", "E", "N", "T", "O", "C", "K", "A", "M", "F"], cipherMap: Cipher.cipherMap2, lineBreakElement: LineBreakCryptogramCellViewModel()
            )
        )
    }

    static func goodLuck() -> Card {
        Card(
            title: "Good Luck!",
            text: [
                "So go forth, brave code breaker, and crack the secret message!"
            ]
        )
    }
}

#Preview {
    CryptogramInstructions()
}
