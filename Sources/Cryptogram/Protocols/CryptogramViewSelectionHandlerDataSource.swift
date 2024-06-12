import Foundation

public protocol CryptogramViewSelectionHandlerDataSource: AnyObject {
    var rows: [[CryptogramViewCellViewModelProtocol]] { get }
    func item(at indexPath: CryptogramIndexPath) -> CryptogramViewCellViewModelProtocol?
}
