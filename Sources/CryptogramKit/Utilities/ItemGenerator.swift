import Foundation

open class ItemGenerator {
    open func items(for phrase: String, solved: [String], cipherMap: [String: String]) -> [CryptogramItem] {
        phrase.enumerated().map { index, letter -> CryptogramItem in
            let letter = String(letter)

            switch letter {
            case " ":
                return CryptogramItem(
                    id: String(index),
                    value: letter,
                    correctValue: letter,
                    code: "",
                    codeHidden: solved.contains(letter),
                    selectable: false,
                    inputtedAt: nil,
                    type: .space
                )

            case ".", ",", "!", "?":
                return CryptogramItem(
                    id: String(index),
                    value: letter,
                    correctValue: letter,
                    code: "",
                    codeHidden: true,
                    selectable: false,
                    inputtedAt: nil,
                    type: .punctuation
                )

            default:
                let code = cipherMap.first(where: { $0.value == letter })?.key
                return CryptogramItem(
                    id: String(index),
                    value: solved.contains(letter) ? letter : "",
                    correctValue: letter,
                    code: code ?? "",
                    codeHidden: false,
                    selectable: true,
                    inputtedAt: nil,
                    type: .letter
                )
            }
        }
    }
}
