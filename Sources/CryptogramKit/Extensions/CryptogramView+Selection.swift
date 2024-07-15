import Foundation

public extension CryptogramView {
    func selectCell(at indexPath: CryptogramIndexPath, animated: Bool) {
        selectionManager.selectCell(at: indexPath, in: self, animated: animated)
    }

    func deselectCell(animated: Bool) {
        selectionManager.deselectCell(in: self, animated: animated)
        deselectHighlightedCells(animated: animated)
    }

    func deselectHighlightedCells(animated: Bool) {
        selectionManager.deselectHighlightedCells(in: self)
    }

    func highlightCell(at indexPath: CryptogramIndexPath, animated: Bool) {
        selectionManager.highlightCell(at: indexPath, in: self)
    }

    func highlightCells(associatedWithCellAt indexPath: CryptogramIndexPath, animated: Bool) {
        selectionManager.highlightCells(associatedWithCellAt: indexPath, in: self)
    }

    func selectNextCell(animated: Bool) {
        selectionManager.selectNextCell(in: self, animated: animated)
    }

    func selectPreviousCell(animated: Bool) {
        selectionManager.selectPreviousCell(in: self, animated: animated)
    }

    func selectFirstCell(animated: Bool) {
        selectionManager.selectFirstCell(in: self, animated: animated)
    }
}
