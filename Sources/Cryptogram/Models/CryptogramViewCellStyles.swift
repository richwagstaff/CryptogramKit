import UIKit

public struct CryptogramViewCellStyles {
    public var letterColor: UIColor? = .label
    public var codeColor: UIColor? = .secondaryLabel
    public var separatorColor: UIColor? = .separator
    public var backgroundColor: UIColor? = .clear
    public var cornerRadius: CGFloat = 7
    public var borderWidth: CGFloat = 0
    public var borderColor: UIColor? = .clear
    public var letterFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
    public var codeFont: UIFont = .systemFont(ofSize: 13)

    public init() {}

    public static var selected: CryptogramViewCellStyles = {
        var styles = CryptogramViewCellStyles()
        styles.borderColor = .systemBlue
        styles.borderWidth = 1.5
        styles.backgroundColor = .systemYellow.withAlphaComponent(0.1)
        return styles
    }()

    public static var normal: CryptogramViewCellStyles = .init()

    public static var punctuation: CryptogramViewCellStyles = {
        var styles = CryptogramViewCellStyles()
        styles.letterFont = .systemFont(ofSize: 14, weight: .bold)
        styles.separatorColor = .clear
        styles.codeFont = .systemFont(ofSize: 10)
        return styles
    }()

    public static var space: CryptogramViewCellStyles = {
        var styles = CryptogramViewCellStyles()
        styles.letterFont = .systemFont(ofSize: 14, weight: .bold)
        styles.separatorColor = .clear
        styles.codeFont = .systemFont(ofSize: 10)
        return styles
    }()

    public static var highlighted: CryptogramViewCellStyles = {
        var styles = CryptogramViewCellStyles()
        styles.backgroundColor = .systemYellow.withAlphaComponent(0.1)
        return styles
    }()
}
