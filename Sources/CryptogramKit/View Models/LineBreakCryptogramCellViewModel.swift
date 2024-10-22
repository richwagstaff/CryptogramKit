import Foundation

open class LineBreakCryptogramCellViewModel: CryptogramViewCellModel {
    override public init(item: CryptogramItem = CryptogramItem(id: "-", value: "-", correctValue: "-", code: "", codeHidden: true, selectable: false, inputtedAt: nil, type: .punctuation)) {
        super.init(item: item)
        styles[.normal] = .punctuation
        isSelectable = false
    }

    override open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState) {
        super.configure(cell: cell, state: state)
        cell.isSelectable = false
    }

    override public func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat {
        return min(18, cryptogramView.frame.width / 30)
    }
}
