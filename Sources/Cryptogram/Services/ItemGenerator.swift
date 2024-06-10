import Foundation

open class ItemGenerator {
    open func items(for phrase: String, cipherMap: [String: String]) -> [CryptogramItem] {
        phrase.map { letter -> CryptogramItem in
            switch letter {
            case " ":
                return CryptogramItem(id: 0, letter: " ", code: "", selectable: false, type: .space)
            case ".", ",", "!", "?":
                return CryptogramItem(id: 0, letter: String(letter), code: "", selectable: false, type: .punctuation)
            default:
                let letter = String(letter)
                let code = cipherMap[letter] ?? ""
                return CryptogramItem(id: 0, letter: letter, code: code, selectable: true, type: .letter)
            }
        }
    }
}
