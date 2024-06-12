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
}

class CompactCryptogramKeyboardRowGenerator: KeyboardRowGenerating {
    var config: KeyboardConfiguration
    var sizes: KeyboardConfigButtonSizes
    var styles: KeyboardConfigButtonStyles

    var keys: CryptogramKeyboardKeyGenerator {
        CryptogramKeyboardKeyGenerator(sizes: sizes, styles: styles)
    }

    init(
        config: KeyboardConfiguration,
        sizes: KeyboardConfigButtonSizes,
        styles: KeyboardConfigButtonStyles
    ) {
        self.config = config
        self.sizes = sizes
        self.styles = styles
    }

    func row(for type: KeyboardRowType) -> KeyboardRow {
        return normalKeyboardRow(for: type)
    }

    func normalKeyboardRow(for type: KeyboardRowType) -> KeyboardRow {
        switch type {
        case .qwerty:
            return KeyboardRow(
                centerKeys: keys.characters(rowType: type),
                alignment: .fill
            )
        case .asdf:
            return KeyboardRow(
                centerKeys: keys.characters(rowType: type)
            )
        case .zxcv:
            return KeyboardRow(
                leftKeys: [keys.previous(size: .leftShift)],
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.next(size: .delete)]
            )
        case .spaceBar:
            return KeyboardRow()
        case .custom:
            return KeyboardRow()
        }
    }
}
