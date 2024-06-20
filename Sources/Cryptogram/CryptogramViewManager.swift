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

    func selectedItem(in cryptogramView: CryptogramView) -> CryptogramViewCellViewModelProtocol? {
        guard let indexPath = cryptogramView.selectedIndexPath else { return nil }
        return item(at: indexPath)
    }

    public init(rows: [[CryptogramViewCellViewModelProtocol]]) {
        self.rows = rows
    }

    /*
     open func inputCharacter(_ character: String, into cryptogramView: CryptogramView) {
         guard
             let indexPath = cryptogramView.selectedIndexPath,
             let cell = cryptogramView.cell(at: indexPath),
             let viewModel = item(at: indexPath)
         else { return }

         if viewModel.isCorrectValue(character) {
             viewModel.setValue(character, cell: cell, in: cryptogramView)

             let remainingIndexPaths = indexPaths(where: { item in
                 item.isAssociated(with: viewModel)
             })

             for indexPath in remainingIndexPaths {
                 guard let viewModel = item(at: indexPath) else { continue }
                 viewModel.fill()
             }

             cryptogramView.reloadCells(at: remainingIndexPaths)

             delegate?.cryptogramViewManager(self, didModifyItemAt: indexPath, in: cryptogramView)

             deselectHighlightedCells(in: cryptogramView)
             selectNextCell(in: cryptogramView)

             if isCompleted() {
                 delegate?.cryptogramViewManager(self, didComplete: cryptogramView)
                 deselectCell(in: cryptogramView)
             }
         }
         else {
             delegate?.cryptogramViewManager(self, didInputWrongAnswerAt: indexPath, in: cryptogramView)
         }
     }*/

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

    public func cryptogramView(_ cryptogramView: CryptogramView, didDeselectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        //configure(cell: cell, state: .normal, at: indexPath)
        //cryptogramView.deselectHighlightedCells()

        // deselectHighlightedCells(in: cryptogramView)
    }

    public func cryptogramView(_ cryptogramView: CryptogramView, didSelectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        //configure(cell: cell, state: .selected, at: indexPath)

       // cryptogramView.highlightCells(associatedWithCellAt: indexPath)

        // delegate?.cryptogramViewManager(self, didSelectItemAt: indexPath, in: cryptogramView)
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

    public func didSelectCell(at indexPath: CryptogramIndexPath) {}

    // MARK: - Selection

    /*
     open func selectCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         selectionManager.selectCell(at: indexPath, in: cryptogramView)
     }

     open func deselectCell(in cryptogramView: CryptogramView) {
         selectionManager.deselectCell(in: cryptogramView)
         deselectHighlightedCells(in: cryptogramView)
     }

     open func deselectHighlightedCells(in cryptogramView: CryptogramView) {
         selectionManager.deselectHighlightedCells(in: cryptogramView)
     }

     open func highlightCell(at indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         selectionManager.highlightCell(at: indexPath, in: cryptogramView)
     }

     public func highlightCells(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         selectionManager.highlightCells(associatedWith: indexPath, in: cryptogramView)
     }

     open func highlightCellIndexPaths(associatedWith indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) -> [CryptogramIndexPath] {
         selectionManager.highlightCellIndexPaths(associatedWith: indexPath, in: cryptogramView)
     }

     open func selectNextCell(in cryptogramView: CryptogramView) {
         selectionManager.selectNextCell(in: cryptogramView)
     }

     open func selectPreviousCell(in cryptogramView: CryptogramView) {
         selectionManager.selectPreviousCell(in: cryptogramView)
     }

     open func selectFirstCell(in cryptogramView: CryptogramView) {
         selectionManager.selectFirstCell(in: cryptogramView)
     }*/
}

public extension CryptogramViewManager {
    convenience init(phrase: String, revealed: [String], maxColumnsPerRow: Int, uppercase: Bool = true, cipherMap: [String: String]) {
        let generator = ItemGenerator()
        let items = generator.items(for: uppercase ? phrase.uppercased() : phrase, revealed: revealed, cipherMap: cipherMap)

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
