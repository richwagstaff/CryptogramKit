import Foundation

public extension CryptogramView {
    func selectCell(at indexPath: CryptogramIndexPath) {
        selectionManager.selectCell(at: indexPath, in: self)
    }

    func deselectCell() {
        selectionManager.deselectCell(in: self)
        deselectHighlightedCells()
    }

    func deselectHighlightedCells() {
        selectionManager.deselectHighlightedCells(in: self)
    }

    func highlightCell(at indexPath: CryptogramIndexPath) {
        selectionManager.highlightCell(at: indexPath, in: self)
    }

    func highlightCells(associatedWithCellAt indexPath: CryptogramIndexPath) {
        selectionManager.highlightCells(associatedWithCellAt: indexPath, in: self)
    }

    func selectNextCell() {
        selectionManager.selectNextCell(in: self)
    }

    func selectPreviousCell() {
        selectionManager.selectPreviousCell(in: self)
    }

    func selectFirstCell() {
        selectionManager.selectFirstCell(in: self)
    }
}
