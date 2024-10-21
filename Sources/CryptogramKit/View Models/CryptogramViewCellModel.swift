import UIKit

open class CryptogramViewCellModel: CryptogramViewCellViewModelProtocol, BreakableElement {
    public var isBreakable: Bool
    public var isSelectable: Bool
    public var id: String { item.id }
    public var value: String { item.value }
    public var item: CryptogramItem
    public var styles: [CryptogramViewCellState: CryptogramViewCellStyles] = [
        .normal: .normal,
        .selected: .selected,
        .highlighted: .highlighted
    ]

    public init(item: CryptogramItem) {
        self.item = item
        self.isBreakable = item.type == .space
        self.isSelectable = item.selectable
    }

    open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState) {
        let styles = styles[state] ?? .normal

        cell.letterLabel.text = item.value
        cell.letterLabel.textColor = styles.letterColor
        cell.letterLabel.font = styles.letterFont

        cell.codeLabel.text = item.code
        cell.codeLabel.textColor = styles.codeColor
        cell.codeLabel.font = styles.codeFont

        cell.codeLabel.isHidden = item.codeHidden

        cell.separator.backgroundColor = styles.separatorColor
        cell.contentView.backgroundColor = styles.backgroundColor
        cell.contentView.layer.cornerRadius = styles.cornerRadius
        cell.contentView.layer.borderWidth = styles.borderWidth
        cell.contentView.layer.borderColor = styles.borderColor?.cgColor
    }

    public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(30, cryptogramView.frame.width / 15)
    }

    public func isAssociated(with selectedViewModel: CryptogramViewCellViewModelProtocol) -> Bool {
        guard let selectedViewModel = selectedViewModel as? CryptogramViewCellModel else { return false }
        return item.code == selectedViewModel.item.code
    }

    public func fill() {
        item.value = item.correctValue
    }

    public func isFilled() -> Bool {
        !item.value.isEmpty
    }

    public func isCorrect() -> Bool {
        item.correctValue == item.value
    }

    public func isCorrectValue(_ value: String) -> Bool {
        item.correctValue == value
    }
}
