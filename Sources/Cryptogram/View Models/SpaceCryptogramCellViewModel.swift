import UIKit

open class SpaceCryptogramCellViewModel: CryptogramViewCellViewModel {
    override public init(item: CryptogramItem) {
        super.init(item: item)
        styles = .space
    }

    override open func configure(cell: CryptogramViewCell, isSelected: Bool) {
        super.configure(cell: cell, isSelected: isSelected)
        cell.isSelectable = false
    }

    override public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(18, cryptogramView.frame.width / 30)
    }
}
