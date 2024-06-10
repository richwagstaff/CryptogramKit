import UIKit

open class SpaceCryptogramCellViewModel: CryptogramViewCellViewModel {
    override public init(item: CryptogramItem) {
        super.init(item: item)
        styles[.normal] = .space
    }

    override open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState) {
        super.configure(cell: cell, state: state)
        cell.isSelectable = false
    }

    override public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(18, cryptogramView.frame.width / 30)
    }
}
