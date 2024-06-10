import UIKit

open class CryptogramViewManager: CryptogramViewDataSource, CryptogramViewDelegate {
    public var rows: [[CryptogramViewCellViewModelProtocol]] = []

    public var highlightedCellIndexPaths: [CryptogramIndexPath] = []

    public init(
        rows: [[CryptogramViewCellViewModelProtocol]]
    ) {
        self.rows = rows
    }

    func item(at indexPath: CryptogramIndexPath) -> CryptogramViewCellViewModelProtocol? {
        guard rows.count > indexPath.row else {
            return nil
        }

        let row = rows[indexPath.row]
        guard row.count > indexPath.column else {
            return nil
        }

        return row[indexPath.column]
    }

    public func numberOfRows(in cryptogramView: CryptogramView) -> Int {
        rows.count
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, numberOfItemsInRow row: Int) -> Int {
        rows[row].count
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, heightForRow row: Int) -> CGFloat {
        60
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, widthForCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) -> CGFloat {
        return item(at: indexPath)?.width(for: cell, in: cryptogramView) ?? 28
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, cellForRowAt indexPath: CryptogramIndexPath, reusableCell: CryptogramViewCell?) -> CryptogramViewCell {
        let cell = reusableCell ?? CryptogramViewCell()

        let state = state(for: indexPath, in: cryptogramView)
        configure(cell: cell, state: state, at: indexPath)

        return cell
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, didDeselectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        configure(cell: cell, state: .normal, at: indexPath)
        deselectHighlightedCells(in: cryptogramView)
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, didSelectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        selectCell(at: indexPath, in: cryptogramView)
    }

    open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState, at indexPath: CryptogramIndexPath) {
        let viewModel = item(at: indexPath)
        viewModel?.configure(cell: cell, state: state)
    }

    open func state(for indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> CryptogramViewCellState {
        if indexPath == cryptogramView.selectedIndexPath {
            return .selected
        }
        else if highlightedCellIndexPaths.contains(indexPath) {
            return .highlighted
        }
        else {
            return .normal
        }
    }

    /// Change all the highlighted cells  back to normal
    open func deselectHighlightedCells(in cryptogramView: CryptogramView) {
        for indexPath in highlightedCellIndexPaths {
            guard let cell = cryptogramView.cell(at: indexPath) else { continue }
            configure(cell: cell, state: .normal, at: indexPath)
        }

        highlightedCellIndexPaths = []
    }

    open func selectCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }

        deselectHighlightedCells(in: cryptogramView)
        highlightCells(associatedWith: indexPath, in: cryptogramView)
        configure(cell: cell, state: .selected, at: indexPath)
    }

    open func highlightCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard let cell = cryptogramView.cell(at: indexPath) else { return }
        configure(cell: cell, state: .highlighted, at: indexPath)

        highlightedCellIndexPaths.append(indexPath)
    }

    public func highlightCells(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        let indexPaths = highlightCellIndexPaths(associatedWith: indexPath, in: cryptogramView)

        for indexPath in indexPaths {
            highlightCell(at: indexPath, in: cryptogramView)
        }
    }

    open func highlightCellIndexPaths(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> [CryptogramIndexPath] {
        guard let selectedViewModel = item(at: indexPath) else { return [] }

        var indexPaths: [CryptogramIndexPath] = []
        for (rowIndex, row) in rows.enumerated() {
            for (columnIndex, item) in row.enumerated() {
                if item.isAssociated(with: selectedViewModel) {
                    let indexPath = CryptogramIndexPath(row: rowIndex, column: columnIndex)
                    indexPaths.append(indexPath)
                }
            }
        }

        return indexPaths
    }
}

public extension CryptogramViewManager {
    convenience init(phrase: String, maxColumnsPerRow: Int, uppercase: Bool = true, cipherMap: [String: String]) {
        let generator = ItemGenerator()
        let items = generator.items(for: uppercase ? phrase.uppercased() : phrase, cipherMap: cipherMap)

        self.init(items: items, maxColumnsPerRow: maxColumnsPerRow)
    }

    convenience init(
        items: [CryptogramViewCellViewModel],
        maxColumnsPerRow: Int
    ) {
        let rows = items.chunk(targetChunkSize: maxColumnsPerRow)
        self.init(rows: rows)
    }

    convenience init(
        items: [CryptogramItem],
        maxColumnsPerRow: Int
    ) {
        let viewModels = CellViewModelGenerator().viewModels(for: items)
        self.init(items: viewModels, maxColumnsPerRow: maxColumnsPerRow)
    }
}
