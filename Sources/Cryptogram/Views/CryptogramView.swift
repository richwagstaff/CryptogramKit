// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

open class CryptogramView: UIView {
    var rows: [CryptogramRowView] = []

    private var needsReloadData = true

    override open var frame: CGRect {
        didSet {
            if frame.size != oldValue.size {
                needsReloadData = true
            }
        }
    }

    public var selectedIndexPath: CryptogramIndexPath?

    public weak var dataSource: CryptogramViewDataSource?
    public weak var delegate: CryptogramViewDelegate?

    override open var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: rows.reduce(0) { $0 + $1.frame.height })
    }

    open func reloadData() {
        rows.forEach { $0.removeFromSuperview() }
        rows = []

        // TODO: Update/change rows. And remove the need for layout constraints in them.
        guard let dataSource = dataSource else { return }

        let numberOfRows = dataSource.numberOfRows(in: self)
        for row in 0 ..< numberOfRows {
            let rowView = createRow(at: row)
            addSubview(rowView)
            rows.append(rowView)
        }

        alignRows()

        invalidateIntrinsicContentSize()
    }

    func createRow(at index: Int) -> CryptogramRowView {
        let row = CryptogramRowView()
        row.row = index
        row.dataSource = self
        row.delegate = self
        row.reloadData()
        return row
    }

    func alignRows() {
        var previousRow: UIView?
        for (index, row) in rows.enumerated() {
            row.frame.size.width = frame.width
            row.frame.size.height = dataSource?.cryptogramView(self, heightForRow: index) ?? 30
            row.center.x = center.x
            row.frame.origin.y = previousRow?.frame.maxY ?? 0
            previousRow = row
        }
    }

    func cell(at indexPath: CryptogramIndexPath) -> CryptogramViewCell? {
        guard indexPath.row < rows.count else { return nil }
        let row = rows[indexPath.row]

        guard indexPath.column < row.cells.count else { return nil }
        return row.cells[indexPath.column]
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if needsReloadData {
            reloadData()
            needsReloadData = false
        }
    }

    open func selectCell(at indexPath: CryptogramIndexPath) {
        guard
            indexPath != selectedIndexPath,
            let cell = cell(at: indexPath),
            cell.isSelectable
        else {
            return
        }

        deselectSelectedCell()

        selectedIndexPath = indexPath
        didSelectCell(cell, at: indexPath)
    }

    open func deselectSelectedCell() {
        guard
            let indexPath = selectedIndexPath,
            let cell = cell(at: indexPath)
        else {
            return
        }

        selectedIndexPath = nil
        didDeselectCell(cell, at: indexPath)
    }

    open func didDeselectCell(_ cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        delegate?.cryptogramView(self, didDeselectCell: cell, at: indexPath)
    }

    open func didSelectCell(_ cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {
        delegate?.cryptogramView(self, didSelectCell: cell, at: indexPath)
    }
}

extension CryptogramView: CryptogramRowViewDataSource {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, numberOfItemsInRow row: Int) -> Int {
        dataSource?.cryptogramView(self, numberOfItemsInRow: row) ?? 0
    }

    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, widthForCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) -> CGFloat {
        return dataSource?.cryptogramView(self, widthForCell: cell, at: indexPath) ?? 28
    }

    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, cellForRowAt indexPath: CryptogramIndexPath, reusableCell: CryptogramViewCell?) -> CryptogramViewCell {
        dataSource?.cryptogramView(self, cellForRowAt: indexPath, reusableCell: reusableCell) ?? CryptogramViewCell()
    }
}

extension CryptogramView: CryptogramRowViewDelegate {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, didSelectCell cell: CryptogramViewCell, at index: Int) {
        guard let row = cryptogramRowView.row else { return }
        let indexPath = CryptogramIndexPath(row: row, column: index)
        selectCell(at: indexPath)
    }
}


@available(iOS 17.0, *)
#Preview {
    CryptogramViewController()
}
