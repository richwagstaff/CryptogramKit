import Foundation

open class CellViewModelGenerator {
    open func viewModels(for items: [CryptogramItem]) -> [CryptogramViewCellViewModel] {
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

    open func viewModels(for phrase: String, cipherMap: [String: String]) -> [CryptogramViewCellViewModel] {
        let items = ItemGenerator().items(for: phrase, cipherMap: cipherMap)
        return viewModels(for: items)
    }
}
