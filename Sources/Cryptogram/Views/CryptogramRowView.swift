import UIKit

protocol CryptogramRowViewDelegate: AnyObject {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, didSelectItemAt index: Int)
}

protocol CryptogramRowViewDataSource: AnyObject {
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, numberOfItemsInRow row: Int) -> Int
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, widthForCellInRow row: Int, at index: Int) -> CGFloat
    func cryptogramRowView(_ cryptogramRowView: CryptogramRowView, cellForRowAt row: Int, at index: Int, reusableCell: CryptogramViewCell?) -> CryptogramViewCell
}

class CryptogramRowView: UIView, CryptogramViewCellSelectionDelegate {
    var row: Int?

    var cells: [CryptogramViewCell] = []

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    weak var dataSource: CryptogramRowViewDataSource?
    weak var delegate: CryptogramRowViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
    }

    func reloadData() {
        cells.forEach { cell in
            cell.removeFromSuperview()
        }

        guard let dataSource = dataSource, let row = row else { return }

        let numberOfItems = dataSource.cryptogramRowView(self, numberOfItemsInRow: row)
        var previousCell: CryptogramViewCell?

        for index in 0 ..< numberOfItems {
            let cell = dataSource.cryptogramRowView(self, cellForRowAt: row, at: index, reusableCell: nil)
            cell.index = index
            cell.selectionDelegate = self

            cells.append(cell)
            containerView.addSubview(cell)

            cell.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(dataSource.cryptogramRowView(self, widthForCellInRow: row, at: index))

                if let previousCell = previousCell {
                    make.leading.equalTo(previousCell.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }

                if index == numberOfItems - 1 {
                    make.trailing.equalToSuperview()
                }
            }

            previousCell = cell
        }
    }

    func didSelectCryptogramViewCell(_ cryptogramViewCell: CryptogramViewCell) {
        guard let index = cryptogramViewCell.index else { return }
        delegate?.cryptogramRowView(self, didSelectItemAt: index)
    }
}
