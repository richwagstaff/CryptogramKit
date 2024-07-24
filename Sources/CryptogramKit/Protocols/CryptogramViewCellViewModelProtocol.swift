import Foundation

public protocol CryptogramViewCellViewModelProtocol: Chunkable {
    // Properties
    var id: String { get }
    var value: String { get }
    var isBreakPoint: Bool { get }
    var isSelectable: Bool { get }

    // Configuration
    func configure(cell: CryptogramViewCell, state: CryptogramViewCellState)

    // Layout
    func width(for cell: CryptogramViewCell, in cryptogramView: CryptogramView) -> CGFloat

    // State Handling
    func isFilled() -> Bool

    // Validation
    func isAssociated(with selectedViewModel: CryptogramViewCellViewModelProtocol) -> Bool
    func isCorrectValue(_ value: String) -> Bool
}
