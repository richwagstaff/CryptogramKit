// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol CryptogramViewDelegate: AnyObject {
    func cellSelected(at index: Int, row: Int)
}

public protocol CryptogramViewDataSource: AnyObject {
    func numberOfRows(in cryptogramView: CryptogramView) -> Int
    func cryptogramView(_ cryptogramView: CryptogramView, numberOfItemsInRow row: Int) -> Int
    func cryptogramView(_ cryptogramView: CryptogramView, heightForRowAt row: Int) -> CGFloat
    func cryptogramView(_ cryptogramView: CryptogramView, widthForCellInRow row: Int, at index: Int) -> CGFloat
    func cryptogramView(_ cryptogramView: CryptogramView, cellForRowAt row: Int, at index: Int, reusableCell: CryptogramViewCell?) -> CryptogramViewCell
}

open class CryptogramView: UIView {
    var rows: [CryptogramRowView] = []

    public weak var dataSource: CryptogramViewDataSource?
    public weak var delegate: CryptogramViewDelegate?

    open func reloadData() {
        rows.forEach { $0.removeFromSuperview() }

        guard let dataSource = dataSource else { return }

        let numberOfRows = dataSource.numberOfRows(in: self)
        var previousRow: CryptogramRowView?
        for row in 0 ..< numberOfRows {
            let rowView = createRow(at: row)
            addSubview(rowView)

            rowView.snp.makeConstraints { make in
                make.height.equalTo(dataSource.cryptogramView(self, heightForRowAt: row))
                make.leading.trailing.equalToSuperview()

                if let previousRow = previousRow {
                    make.top.equalTo(previousRow.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }

                if row == numberOfRows - 1 {
                    make.bottom.equalToSuperview()
                }
            }

            previousRow = rowView
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
}

extension CryptogramView: CryptogramRowViewDataSource {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, numberOfItemsInRow row: Int) -> Int {
        dataSource?.cryptogramView(self, numberOfItemsInRow: row) ?? 0
    }

    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, widthForCellInRow row: Int, at index: Int) -> CGFloat {
        dataSource?.cryptogramView(self, widthForCellInRow: row, at: index) ?? 28
    }

    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, cellForRowAt row: Int, at index: Int, reusableCell: CryptogramViewCell?) -> CryptogramViewCell {
        return dataSource?.cryptogramView(self, cellForRowAt: row, at: index, reusableCell: nil) ?? CryptogramViewCell()
    }
}

extension CryptogramView: CryptogramRowViewDelegate {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, didSelectItemAt index: Int) {
        guard let row = cryptogramRowView.row else { return }
        delegate?.cellSelected(at: index, row: row)
        print("Selected cell at row \(row), index \(index)")
    }
}

private class DataSource: CryptogramViewDataSource {
    func numberOfRows(in cryptogramView: CryptogramView) -> Int {
        return 5
    }

    func cryptogramView(_ cryptogramView: CryptogramView, numberOfItemsInRow row: Int) -> Int {
        return Int.random(in: 6 ... 15)
    }

    func cryptogramView(_ cryptogramView: CryptogramView, heightForRowAt row: Int) -> CGFloat {
        return 60
    }

    func cryptogramView(_ cryptogramView: CryptogramView, widthForCellInRow row: Int, at index: Int) -> CGFloat {
        return 28
    }

    func cryptogramView(_ cryptogramView: CryptogramView, cellForRowAt row: Int, at index: Int, reusableCell: CryptogramViewCell?) -> CryptogramViewCell {
        let cell = CryptogramViewCell()
        let viewModel = CryptogramViewCellViewModel(letter: "A", code: "6", styles: CryptogramViewCellStyles(), selectedStyles: CryptogramViewCellStyles())
        viewModel.configure(cell: cell)
        return cell
    }
}

@available(iOS 17.0, *)
#Preview {
    let dataSource = DataSource()
    let cryptogramView = CryptogramView()
    cryptogramView.dataSource = dataSource
    cryptogramView.reloadData()
    return cryptogramView
}
