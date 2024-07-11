import Foundation
import KeyboardKit

open class CryptogramKeyboardKeyGenerator {
    public var sizes: KeyboardConfigButtonSizes
    public var styles: KeyboardConfigButtonStyles

    init(sizes: KeyboardConfigButtonSizes, styles: KeyboardConfigButtonStyles) {
        self.sizes = sizes
        self.styles = styles
    }

    func key(_ type: CryptogramKeyboardKeyType, data: Any? = nil, size: KeyboardConfigButtonSizes.SizeType?) -> KeyboardKey {
        let size = keyboardButtonSize(size)
        switch type {
        case .character:
            return .character("") // Will never be used
        case .next:
            return .next(size: size, styles: styles.accessory)
        case .previous:
            return .previous(size: size, styles: styles.accessory)
        case .blank:
            return .blank(size: size, styles: styles.accessory)
        }
    }

    func keyboardButtonSize(_ sizeType: KeyboardConfigButtonSizes.SizeType?) -> KeyboardButtonSize {
        guard let sizeType = sizeType else { return KeyboardButtonSize() }
        return sizes.get(sizeType) ?? KeyboardButtonSize()
    }

    func characters(
        rowType: KeyboardRowType,
        uppercase: Bool = true,
        size: KeyboardButtonSize? = nil
    ) -> [KeyboardKey] {
        return rowType.characterKeyboardKeys(
            uppercase: uppercase,
            size: size ?? sizes.character,
            styles: styles.character
        )
    }

    func previous(size: KeyboardConfigButtonSizes.SizeType? = nil) -> KeyboardKey {
        .previous(size: keyboardButtonSize(size), styles: styles.accessory)
    }

    func next(size: KeyboardConfigButtonSizes.SizeType? = nil) -> KeyboardKey {
        .next(size: keyboardButtonSize(size), styles: styles.accessory)
    }

    func blank(size: KeyboardConfigButtonSizes.SizeType?) -> KeyboardKey {
        .blank(size: keyboardButtonSize(size), styles: styles.accessory)
    }

    func hidden(size: KeyboardConfigButtonSizes.SizeType?) -> KeyboardKey {
        .blank(hidden: true, size: keyboardButtonSize(size))
    }
}
