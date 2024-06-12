import Foundation

open class CryptogramViewSelectionManager {
    public weak var dataSource: CryptogramViewSelectionHandlerDataSource?
    public weak var delegate: CryptogramViewSelectionHandlerDelegate?

    public var rows: [[CryptogramViewCellViewModelProtocol]] {
        dataSource?.rows ?? []
    }

    open func item(at indexPath: CryptogramIndexPath) -> CryptogramViewCellViewModelProtocol? {
        dataSource?.item(at: indexPath)
    }

    open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState, at indexPath: CryptogramIndexPath) {
        delegate?.configure(cell: cell, state: state, at: indexPath)
    }

    open func setCellState(_ state: CryptogramViewCellState, at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }
        configure(cell: cell, state: state, at: indexPath)
    }

    open func deselectCell(in cryptogramView: CryptogramView) {
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

    open func selectCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }

        deselectHighlightedCells(in: cryptogramView)
        highlightCells(associatedWith: indexPath, in: cryptogramView)
        cryptogramView.selectedIndexPath = indexPath
        configure(cell: cell, state: .selected, at: indexPath)
    }

    open func highlightCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }
        configure(cell: cell, state: .highlighted, at: indexPath)

        cryptogramView.highlightedIndexPaths.append(indexPath)
    }

    public func highlightCells(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        let indexPaths = highlightCellIndexPaths(associatedWith: indexPath, in: cryptogramView)

        for indexPath in indexPaths {
            highlightCell(at: indexPath, in: cryptogramView)
        }
    }

    open func highlightCellIndexPaths(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> [CryptogramIndexPath] {
        indexPaths(associatedWith: indexPath)
    }

    open func indexPaths(associatedWith indexPath: CryptogramIndexPath) -> [CryptogramIndexPath] {
        guard let selectedViewModel = item(at: indexPath) else { return [] }
        return indexPaths(where: { $0.isAssociated(with: selectedViewModel) })
    }

    open func selectPreviousCell(in cryptogramView: CryptogramView) {
        selectNextCell(in: cryptogramView, forward: false)
    }

    open func selectNextCell(in cryptogramView: CryptogramView, forward: Bool = true) {
        guard
            let selectedIndexPath = cryptogramView.selectedIndexPath,
            let indexPath = firstEmptyIndexPath(after: selectedIndexPath, forward: forward) ?? firstSelectableIndexPath(after: selectedIndexPath, forward: forward)
        else {
            return
        }

        selectCell(at: indexPath, in: cryptogramView)
    }

    open func selectFirstCell(in cryptogramView: CryptogramView) {
        guard let indexPath = emptyIndexPaths().first ?? allIndexPaths().first else { return }
        selectCell(at: indexPath, in: cryptogramView)
    }

    open func indexPath(before indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        arrangedIndexPaths(startingAfter: indexPath, ascending: false).first
    }

    open func indexPath(after indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        arrangedIndexPaths(startingAfter: indexPath, ascending: true).first
    }

    open func firstSelectableIndexPath(after indexPath: CryptogramIndexPath, forward: Bool = true) -> CryptogramIndexPath? {
        let arrangedIndexPaths = arrangedIndexPaths(startingAfter: indexPath, ascending: true)

        return arrangedIndexPaths.first(where: { indexPath in
            let item = self.item(at: indexPath)
            return item?.isSelectable == true
        })
    }

    open func firstEmptyIndexPath(after indexPath: CryptogramIndexPath, forward: Bool = true) -> CryptogramIndexPath? {
        let arrangedIndexPaths = arrangedIndexPaths(startingAfter: indexPath, ascending: forward)

        return arrangedIndexPaths.first(where: { indexPath in
            let item = self.item(at: indexPath)
            return item?.isFilled() == false && item?.isSelectable == true
        })
    }

    open func firstEmptyIndexPath(before indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        firstEmptyIndexPath(after: indexPath, forward: false)
    }

    open func emptyIndexPaths() -> [CryptogramIndexPath] {
        indexPaths(where: { $0.isFilled() == false && $0.isSelectable == true })
    }

    open func allIndexPaths() -> [CryptogramIndexPath] {
        var indexPaths: [CryptogramIndexPath] = []

        for (rowIndex, row) in rows.enumerated() {
            for columnIndex in 0 ..< row.count {
                let indexPath = CryptogramIndexPath(row: rowIndex, column: columnIndex)
                indexPaths.append(indexPath)
            }
        }

        return indexPaths
    }

    open func arrangedIndexPaths(startingAt indexPath: CryptogramIndexPath, ascending: Bool = true) -> [CryptogramIndexPath] {
        let indexPaths = allIndexPaths()
        let sortedIndexPaths = ascending ? indexPaths : indexPaths.reversed()

        guard let startIndex = sortedIndexPaths.firstIndex(of: indexPath) else { return indexPaths }
        let arrangedIndexPaths = sortedIndexPaths[startIndex ..< sortedIndexPaths.count] + sortedIndexPaths[0 ..< startIndex]
        return Array(arrangedIndexPaths)
    }

    public func arrangedIndexPaths(startingAfter indexPath: CryptogramIndexPath, ascending: Bool = true) -> [CryptogramIndexPath] {
        let indexPaths = arrangedIndexPaths(startingAt: indexPath, ascending: ascending)

        // Move first to last position
        guard let first = indexPaths.first else { return indexPaths }
        var arrangedIndexPaths = Array(indexPaths.dropFirst())
        arrangedIndexPaths.append(first)
        return arrangedIndexPaths
    }

    public func indexPathIterator(startingAt indexPath: CryptogramIndexPath? = nil, ascending: Bool = true) -> AnyIterator<CryptogramIndexPath> {
        let indexPath = indexPath ?? CryptogramIndexPath(row: 0, column: 0)
        let indexPaths = arrangedIndexPaths(startingAt: indexPath, ascending: ascending)
        var index = 0

        return AnyIterator {
            guard index < indexPaths.count else { return nil }
            defer { index += 1 }
            return indexPaths[index]
        }
    }

    public func indexPaths(where predicate: (CryptogramViewCellViewModelProtocol) -> Bool) -> [CryptogramIndexPath] {
        var indexPaths: [CryptogramIndexPath] = []

        for path in indexPathIterator() {
            guard let item = item(at: path) else { continue }
            if predicate(item) {
                indexPaths.append(path)
            }
        }

        return indexPaths
    }
}
