import Foundation

open class ItemGenerator {
    open func items(for phrase: String, revealed: [String], cipherMap: [String: String]) -> [CryptogramItem] {
        phrase.enumerated().map { i, letter -> CryptogramItem in
            let letter = String(letter)
            switch letter {
            case " ":
                return CryptogramItem(id: String(i), value: letter, correctValue: letter, code: "", selectable: false, inputtedAt: nil, type: .space)
            case ".", ",", "!", "?":
                return CryptogramItem(id: String(i), value: letter, correctValue: letter, code: "", selectable: false, inputtedAt: nil, type: .punctuation)
            default:
                let code = cipherMap[letter] ?? ""
                return CryptogramItem(id: String(i), value: revealed.contains(letter) ? letter : "", correctValue: letter, code: code, selectable: true, inputtedAt: nil, type: .letter)
            }
        }
    }
}
