import Foundation
import KeyboardKit

class LargeCryptogramKeyboardRowGenerator: KeyboardRowGenerating {
    var config: LargeKeyboardConfiguration
    var sizes: KeyboardConfigButtonSizes
    var styles: KeyboardConfigButtonStyles

    var keys: CryptogramKeyboardKeyGenerator {
        CryptogramKeyboardKeyGenerator(sizes: sizes, styles: styles)
    }

    init(
        config: LargeKeyboardConfiguration,
        sizes: KeyboardConfigButtonSizes,
        styles: KeyboardConfigButtonStyles
    ) {
        self.config = config
        self.sizes = sizes
        self.styles = styles
    }

    func row(for type: KeyboardRowType) -> KeyboardRow {
        switch config.style {
        case .compact:
            return compactRow(for: type)

        case .comprehensive:
            return comprehensiveRow(for: type)

        case .expanded:
            return expandedRow(for: type)
        }
    }

    func compactRow(for type: KeyboardRowType) -> KeyboardRow {
        switch type {
        case .qwerty:
            return KeyboardRow(
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .delete)],
                alignment: .fill
            )
        case .asdf:
            return KeyboardRow(
                leftKeys: .hidden(size: sizes.asdfLeftSpace),
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .returnKey)],
                alignment: .fill
            )
        case .zxcv:
            return KeyboardRow(
                leftKeys: [keys.blank(size: .leftShift)],
                centerKeys: keys.characters(rowType: type) + [
                    keys.previous(size: .character),
                    keys.next(size: .character)
                ],
                rightKeys: [keys.blank(size: .rightShift)],
                alignment: .fill
            )
        case .spaceBar, .custom:
            return KeyboardRow()
        }
    }

    func comprehensiveRow(for type: KeyboardRowType) -> KeyboardRow {
        switch type {
        case .qwerty:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .tab)],
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .delete)],
                alignment: .fill
            )

        case .asdf:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .capsLock)],
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .returnKey)],
                alignment: .fill
            )

        case .zxcv:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .leftShift)],
                centerKeys: keys.characters(rowType: type) + [
                    keys.previous(size: .character).with(contentIn: .bottomRight),
                    keys.next(size: .character).with(contentIn: .bottomRight)
                ],
                rightKeys: [keys.blank(size: .rightShift)],
                alignment: .fill
            )

        case .spaceBar, .custom:
            return KeyboardRow()
        }
    }

    func expandedRow(for type: KeyboardRowType) -> KeyboardRow {
        switch type {
        case .qwerty:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .tab)],
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .delete)],
                alignment: .left
            )

        case .asdf:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .capsLock)],
                centerKeys: keys.characters(rowType: type),
                rightKeys: [keys.blank(size: .returnKey)],
                alignment: .left
            )

        case .zxcv:
            return .withDescriptiveStyle(
                leftKeys: [keys.blank(size: .leftShift)],
                centerKeys: keys.characters(rowType: type) + [
                    keys.previous(size: .character).with(contentType: .text, in: .bottomRight),
                    keys.next(size: .character).with(contentType: .text, in: .bottomRight)
                ],
                rightKeys: [keys.blank(size: .rightShift)],
                alignment: .fill
            )

        case .spaceBar, .custom:
            return KeyboardRow()
        }
    }
}
