import Combine
import UIKit

open class CryptogramView: UIView, ObservableObject {
    var rows: [CryptogramRowView] = []

    private var oldSize: CGSize = .zero

    @Published public var selectedIndexPath: CryptogramIndexPath?
    @Published public var highlightedIndexPaths: [CryptogramIndexPath] = []

    public weak var dataSource: CryptogramViewDataSource?
    public weak var delegate: CryptogramViewDelegate?

    public var selectionManager = CryptogramViewSelectionManager()

    override open var intrinsicContentSize: CGSize {
        let totalRowHeight = rows.reduce(0) { $0 + $1.frame.height }
        let totalSpacing = CGFloat(rows.count - 1) * (dataSource?.rowSpacing(in: self) ?? 0)
        return CGSize(width: UIView.noIntrinsicMetric, height: totalRowHeight + totalSpacing)
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

    open func reloadCells(at indexPaths: [CryptogramIndexPath]) {
        guard let dataSource = dataSource else { return }

        for indexPath in indexPaths {
            guard let cell = cell(at: indexPath) else { continue }
            _ = dataSource.cryptogramView(self, cellForRowAt: indexPath, reusableCell: cell)
        }
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
        let spacing = dataSource?.rowSpacing(in: self) ?? 0

        var previousRow: UIView?
        for (index, row) in rows.enumerated() {
            row.frame.size.width = frame.width
            row.frame.size.height = dataSource?.cryptogramView(self, heightForRow: index) ?? 30
            row.center.x = center.x
            row.frame.origin.y = previousRow?.frame.maxY ?? 0

            if index > 0 {
                row.frame.origin.y += spacing
            }

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

        if oldSize != frame.size {
            reloadData()
            oldSize = frame.size
        }
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
        selectCell(at: indexPath, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    CryptogramViewController()
}
