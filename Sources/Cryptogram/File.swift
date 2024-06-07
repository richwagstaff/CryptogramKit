import Foundation

open class ItemGenerator {
    func items(from phrase: String, cipherMap: [String: String]) -> [CryptogramItem] {
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

open class CellViewModelGenerator {
    func viewModels(for items: [CryptogramItem]) -> [CryptogramViewCellViewModel] {
        items.map { item in
            switch item.type {
            case .letter:
                return CryptogramViewCellViewModel(item: item)
            case .punctuation:
                return PunctuationCryptogramCellViewModel(item: item)
            case .space:
                return SpaceCryptogramCellViewModel(item: item)
            }
        }
    }

    func viewModels(for phrase: String, cipherMap: [String: String]) -> [CryptogramViewCellViewModel] {
        let items = ItemGenerator().items(from: phrase, cipherMap: cipherMap)
        return viewModels(for: items)
    }
}
