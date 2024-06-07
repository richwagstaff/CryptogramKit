import Foundation

public protocol CryptogramViewCellViewModelProtocol: Chunkable {
    var isBreakPoint: Bool { get }
    func configure(cell: CryptogramViewCell, isSelected: Bool)
    func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat
}
