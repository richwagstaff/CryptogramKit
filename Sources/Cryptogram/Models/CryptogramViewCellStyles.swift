import UIKit
public struct CryptogramViewCellStyles {
    var letterColor: UIColor? = .label
    var codeColor: UIColor? = .secondaryLabel
    var separatorColor: UIColor? = .separator
    var backgroundColor: UIColor? = .systemGray6
    var cornerRadius: CGFloat = 4
    var borderWidth: CGFloat = 0
    var borderColor: UIColor? = .clear
    var letterFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
    var codeFont: UIFont = .systemFont(ofSize: 14)

    public init() {}
}
