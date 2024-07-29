import UIKit

public protocol CryptogramViewManagerDelegate: AnyObject {
    func cryptogramViewManager(_ manager: CryptogramViewManager, didSelectItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView)
    func cryptogramViewManager(_ manager: CryptogramViewManager, didModifyItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView)
    func cryptogramViewManager(_ manager: CryptogramViewManager, didInputWrongAnswerAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView)
}

open class CryptogramViewManager: CryptogramViewDataSource, CryptogramViewDelegate, CryptogramViewSelectionHandlerDelegate, CryptogramViewSelectionHandlerDataSource, CryptogramRowHandling {
    public var rows: [[CryptogramViewCellViewModelProtocol]] = []
    public weak var delegate: CryptogramViewManagerDelegate?
    public lazy var selectionManager: CryptogramViewSelectionManager = {
        let manager = CryptogramViewSelectionManager()
        manager.dataSource = self
        manager.delegate = self
        return manager
    }()

    public func configure(_ cryptogramView: CryptogramView) {
        cryptogramView.dataSource = self
        cryptogramView.delegate = self

        cryptogramView.selectionManager = selectionManager

        cryptogramView.invalidateIntrinsicContentSize()
    }

    func selectedItem(in cryptogramView: CryptogramView) -> CryptogramViewCellViewModelProtocol? {
        guard let indexPath = cryptogramView.selectedIndexPath else { return nil }
        return item(at: indexPath)
    }

    public init(rows: [[CryptogramViewCellViewModelProtocol]]) {
        self.rows = rows
    }

    public func numberOfRows(in cryptogramView: CryptogramView) -> Int {
        rows.count
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, numberOfItemsInRow row: Int) -> Int {
        rows[row].count
    }

    public func rowSpacing(in cryptogramView: CryptogramView) -> CGFloat {
        8
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

    public func cryptogramView(_ cryptogramView: CryptogramView, didDeselectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {}

    public func cryptogramView(_ cryptogramView: CryptogramView, didSelectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        delegate?.cryptogramViewManager(self, didSelectItemAt: indexPath, in: cryptogramView)
    }

    open func configure(cell: CryptogramViewCell, state: CryptogramViewCellState, at indexPath: CryptogramIndexPath) {
        let viewModel = item(at: indexPath)
        viewModel?.configure(cell: cell, state: state)
    }

    open func state(for indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> CryptogramViewCellState {
        if indexPath == cryptogramView.selectedIndexPath {
            return .selected
        }
        else if cryptogramView.highlightedIndexPaths.contains(indexPath) {
            return .highlighted
        }
        else {
            return .normal
        }
    }

    // MARK: - States

    open func isCompleted() -> Bool {
        for row in rows {
            for viewModel in row {
                if !viewModel.isFilled() {
                    return false
                }
            }
        }

        return true
    }

    // MARK: - Selection Delegate

    public func didSelectCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        delegate?.cryptogramViewManager(self, didSelectItemAt: indexPath, in: cryptogramView)
    }
}

public extension CryptogramViewManager {
    convenience init(phrase: String, revealed: [String], maxColumnsPerRow: Int = 15, uppercase: Bool = true, cipherMap: [String: String]) {
        let generator = ItemGenerator()
        let items = generator.items(for: uppercase ? phrase.uppercased() : phrase, solved: revealed, cipherMap: cipherMap)

        self.init(items: items, maxColumnsPerRow: maxColumnsPerRow)
    }

    convenience init(items: [CryptogramViewCellModel], maxColumnsPerRow: Int) {
        let rows = items.chunk(targetChunkSize: maxColumnsPerRow)
        self.init(rows: rows)
    }

    convenience init(items: [CryptogramItem], maxColumnsPerRow: Int) {
        let viewModels = CellViewModelGenerator().viewModels(for: items)
        self.init(items: viewModels, maxColumnsPerRow: maxColumnsPerRow)
    }
}
