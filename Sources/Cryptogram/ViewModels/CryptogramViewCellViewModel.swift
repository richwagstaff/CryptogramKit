import UIKit

open class CryptogramViewCellViewModel {
    let letter: String
    let code: String
    let styles: CryptogramViewCellStyles
    let selectedStyles: CryptogramViewCellStyles

    public init(letter: String, code: String, styles: CryptogramViewCellStyles, selectedStyles: CryptogramViewCellStyles) {
        self.letter = letter
        self.code = code
        self.styles = styles
        self.selectedStyles = selectedStyles
    }

    open func configure(cell: CryptogramViewCell) {
        let styles = styles(for: cell.isSelected)

        cell.letterLabel.text = letter
        cell.letterLabel.textColor = styles.letterColor
        cell.letterLabel.font = styles.letterFont

        cell.codeLabel.text = code
        cell.codeLabel.textColor = styles.codeColor
        cell.codeLabel.font = styles.codeFont

        cell.separator.backgroundColor = styles.separatorColor
        cell.contentView.backgroundColor = styles.backgroundColor
        cell.contentView.layer.cornerRadius = styles.cornerRadius
        cell.contentView.layer.borderWidth = styles.borderWidth
        cell.contentView.layer.borderColor = styles.borderColor?.cgColor
    }

    func styles(for isSelected: Bool) -> CryptogramViewCellStyles {
        return isSelected ? selectedStyles : styles
    }
}
