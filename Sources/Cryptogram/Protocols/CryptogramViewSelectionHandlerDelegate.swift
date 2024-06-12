import Foundation

public protocol CryptogramViewSelectionHandlerDelegate: AnyObject {
    func configure(cell: CryptogramViewCell, state: CryptogramViewCellState, at indexPath: CryptogramIndexPath)
    func didSelectCell(at indexPath: CryptogramIndexPath)
}
