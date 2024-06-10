import Foundation

public protocol CryptogramViewCellViewModelProtocol: Chunkable {
    var isBreakPoint: Bool { get }
    func configure(cell: CryptogramViewCell, state: CryptogramViewCellState)
    func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat
    func isAssociated(with selectedViewModel: CryptogramViewCellViewModelProtocol) -> Bool
}
