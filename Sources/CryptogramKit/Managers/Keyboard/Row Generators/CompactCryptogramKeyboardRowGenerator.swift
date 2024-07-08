import Foundation
import KeyboardKit

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
