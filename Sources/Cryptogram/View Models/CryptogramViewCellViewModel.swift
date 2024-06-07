import UIKit

open class CryptogramViewCellViewModel: CryptogramViewCellViewModelProtocol, Chunkable {
    public var isBreakPoint: Bool
    public let item: CryptogramItem
    public var styles: CryptogramViewCellStyles = .normal
    public var selectedStyles: CryptogramViewCellStyles = .selected

    public init(item: CryptogramItem) {
        self.item = item
        self.isBreakPoint = item.type == .space
    }

    open func configure(cell: CryptogramViewCell, isSelected: Bool) {
        let styles = styles(isSelected: isSelected)

        cell.letterLabel.text = item.letter
        cell.letterLabel.textColor = styles.letterColor
        cell.letterLabel.font = styles.letterFont

        cell.codeLabel.text = item.code
        cell.codeLabel.textColor = styles.codeColor
        cell.codeLabel.font = styles.codeFont

        cell.separator.backgroundColor = styles.separatorColor
        cell.contentView.backgroundColor = styles.backgroundColor
        cell.contentView.layer.cornerRadius = styles.cornerRadius
        cell.contentView.layer.borderWidth = styles.borderWidth
        cell.contentView.layer.borderColor = styles.borderColor?.cgColor
    }

    public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(28, cryptogramView.frame.width / 17)
    }

    open func styles(isSelected: Bool) -> CryptogramViewCellStyles {
        isSelected ? selectedStyles : styles
    }
}
