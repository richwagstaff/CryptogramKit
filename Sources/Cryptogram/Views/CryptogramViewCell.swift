import Foundation
import SnapKit
import UIKit

protocol CryptogramViewCellSelectionDelegate: AnyObject {
    func didSelectCryptogramViewCell(_ cryptogramViewCell: CryptogramViewCell)
}

open class CryptogramViewCell: UIView {
    var index: Int?
    weak var selectionDelegate: CryptogramViewCellSelectionDelegate?

    private var codeHeightConstraint: Constraint?

    public var contentView = UIView()
    private var innerContentView = UIView()

    private(set) var isSelected = false

    public var margin: UIEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3) {
        didSet {
            if oldValue != margin {
                updateContentViewConstraints()
            }
        }
    }

    public var padding: UIEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3) {
        didSet {
            if oldValue != padding {
                updateContentViewConstraints()
            }
        }
    }

    public lazy var letterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    public lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()

    public lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(contentView)
        contentView.addSubview(innerContentView)
        innerContentView.addSubview(letterLabel)
        innerContentView.addSubview(separator)
        innerContentView.addSubview(codeLabel)

        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(margin)
        }

        innerContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }

        letterLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(letterLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(1)
        }

        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            codeHeightConstraint = make.height.equalTo(codeLabelHeight()).constraint
        }

        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        selectionDelegate?.didSelectCryptogramViewCell(self)
    }

    private func updateCodeHeight() {
        codeHeightConstraint?.update(offset: codeLabelHeight())
    }

    private func codeLabelHeight() -> CGFloat {
        return codeLabel.font.lineHeight + 4
    }

    private func updateContentViewConstraints() {
        contentView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(margin)
        }

        innerContentView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    var selectedStyles = CryptogramViewCellStyles()
    selectedStyles.borderColor = .red
    selectedStyles.borderWidth = 2
    let viewModel = CryptogramViewCellViewModel(letter: "H", code: "4", styles: CryptogramViewCellStyles(), selectedStyles: selectedStyles)
    let cell = CryptogramViewCell()
    // cell.isSelected = true
    viewModel.configure(cell: cell)
    cell.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    return cell
}
