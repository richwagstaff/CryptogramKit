import Foundation

open class CryptogramViewSelectionManager: CryptogramRowHandling {
    public var highlightingEnabled: Bool = false
    public weak var dataSource: CryptogramViewSelectionHandlerDataSource?
    public weak var delegate: CryptogramViewSelectionHandlerDelegate?

    public var rows: [[CryptogramViewCellViewModelProtocol]] {
        dataSource?.rows ?? []
    }

    open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState, at indexPath: CryptogramIndexPath) {
        delegate?.configure(cell: cell, state: state, at: indexPath)
    }

    open func setCellState(_ state: CryptogramViewCellState, at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }
        configure(cell: cell, state: state, at: indexPath)
    }

    open func deselectCell(in cryptogramView: CryptogramView, animated: Bool) {
        guard let indexPath = cryptogramView.selectedIndexPath else { return }
        setCellState(.normal, at: indexPath, in: cryptogramView)
        cryptogramView.selectedIndexPath = nil
    }

    open func deselectHighlightedCells(in cryptogramView: CryptogramView) {
        for indexPath in cryptogramView.highlightedIndexPaths {
            setCellState(.normal, at: indexPath, in: cryptogramView)
        }

        cryptogramView.highlightedIndexPaths = []
    }

    open func selectCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView, animated: Bool) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }

        deselectCell(in: cryptogramView, animated: true)
        deselectHighlightedCells(in: cryptogramView)
        highlightCells(associatedWithCellAt: indexPath, in: cryptogramView)
        cryptogramView.selectedIndexPath = indexPath
        configure(cell: cell, state: .selected, at: indexPath)

        if animated {
            cryptogramView.animations.animateCellSelection(cell)
        }
    }

    open func highlightCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard highlightingEnabled, let cell = cryptogramView.cell(at: indexPath) else { return }
        configure(cell: cell, state: .highlighted, at: indexPath)

        cryptogramView.highlightedIndexPaths.append(indexPath)
    }

    public func highlightCells(associatedWithCellAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        let indexPaths = indexPathsToHighlight(selectedCellIndexPath: indexPath, in: cryptogramView)

        for indexPath in indexPaths {
            highlightCell(at: indexPath, in: cryptogramView)
        }
    }

    open func indexPathsToHighlight(selectedCellIndexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> [CryptogramIndexPath] {
        indexPaths(associatedWith: selectedCellIndexPath)
    }

    open func indexPaths(associatedWith indexPath: CryptogramIndexPath) -> [CryptogramIndexPath] {
        guard let selectedViewModel = item(at: indexPath) else { return [] }
        return indexPaths(where: { $0.isAssociated(with: selectedViewModel) })
    }

    open func selectPreviousCell(in cryptogramView: CryptogramView, animated: Bool) {
        selectNextCell(in: cryptogramView, forward: false, animated: animated)
    }

    open func selectNextCell(in cryptogramView: CryptogramView, forward: Bool = true, animated: Bool) {
        guard
            let selectedIndexPath = cryptogramView.selectedIndexPath,
            let indexPath = firstEmptyIndexPath(after: selectedIndexPath, forward: forward) ?? firstSelectableIndexPath(after: selectedIndexPath, forward: forward)
        else {
            return
        }

        selectCell(at: indexPath, in: cryptogramView, animated: animated)
    }

    open func selectFirstCell(in cryptogramView: CryptogramView, animated: Bool) {
        guard let indexPath = emptyIndexPaths().first ?? allIndexPaths().first else { return }
        selectCell(at: indexPath, in: cryptogramView, animated: animated)
    }

    open func disableSelection() {}

    open func disableHighlights() {}
}
