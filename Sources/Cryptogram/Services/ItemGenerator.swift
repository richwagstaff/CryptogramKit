import Foundation

open class ItemGenerator {
    open func items(for phrase: String, revealed: [String], cipherMap: [String: String]) -> [CryptogramItem] {
        phrase.map { letter -> CryptogramItem in
            let letter = String(letter)
            switch letter {
            case " ":
                return CryptogramItem(id: 0, value: letter, correctValue: letter, code: "", selectable: false, type: .space)
            case ".", ",", "!", "?":
                return CryptogramItem(id: 0, value: letter, correctValue: letter, code: "", selectable: false, type: .punctuation)
            default:
                let code = cipherMap[letter] ?? ""
                return CryptogramItem(id: 0, value: revealed.contains(letter) ? letter : "", correctValue: letter, code: code, selectable: true, type: .letter)
            }
        }
    }
}
