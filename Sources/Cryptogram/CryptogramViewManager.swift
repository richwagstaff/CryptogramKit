import UIKit

open class CryptogramViewManager: CryptogramViewDataSource, CryptogramViewDelegate {
    public var rows: [[CryptogramViewCellViewModelProtocol]] = []

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
        let cell = CryptogramViewCell()
        let viewModel = item(at: indexPath)

        let isSelected = cryptogramView.selectedIndexPath == indexPath

        viewModel?.configure(cell: cell, isSelected: isSelected)
        return cell
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, didDeselectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        let viewModel = item(at: indexPath)
        viewModel?.configure(cell: cell, isSelected: false)
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, didSelectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        let viewModel = item(at: indexPath)
        viewModel?.configure(cell: cell, isSelected: true)
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
