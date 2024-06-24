import Foundation

open class CellViewModelGenerator {
    open func viewModels(for items: [CryptogramItem]) -> [CryptogramViewCellModel] {
        items.map { item in
            switch item.type {
            case .letter:
                return CryptogramViewCellModel(item: item)
            case .punctuation:
                return PunctuationCryptogramCellViewModel(item: item)
            case .space:
                return SpaceCryptogramCellViewModel(item: item)
            }
        }
    }

    open func viewModels(for phrase: String, revealed: [String], cipherMap: [String: String]) -> [CryptogramViewCellModel] {
        let items = ItemGenerator().items(for: phrase, revealed: revealed, cipherMap: cipherMap)
        return viewModels(for: items)
    }
}
