import UIKit

open class PunctuationCryptogramCellViewModel: CryptogramViewCellViewModel {
    override public init(item: CryptogramItem) {
        super.init(item: item)
        styles = .punctuation
    }

    override open func configure(cell: CryptogramViewCell, isSelected: Bool) {
        super.configure(cell: cell, isSelected: isSelected)
        cell.isSelectable = false
    }

    override public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(18, cryptogramView.frame.width / 30)
    }
}
