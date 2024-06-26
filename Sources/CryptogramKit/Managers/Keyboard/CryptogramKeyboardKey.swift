import KeyboardKit
import UIKit

extension Array where Element == KeyboardKey {
    static func character(_ character: String, size: KeyboardButtonSize? = nil, styles: KeyboardButtonStyles? = nil) -> KeyboardKey {
        KeyboardKey.character(character, size: size, styles: styles)
    }

    static func next(size: KeyboardButtonSize? = nil, styles: KeyboardButtonStyles? = nil) -> KeyboardKey {
        KeyboardKey.next(size: size, styles: styles)
    }

    static func previous(size: KeyboardButtonSize? = nil, styles: KeyboardButtonStyles? = nil) -> KeyboardKey {
        KeyboardKey.previous(size: size, styles: styles)
    }
}

extension KeyboardKey {
    static func cryptogramKeyboardKey(
        text: String? = nil,
        imageName: String? = nil,
        highlightedImageName: String? = nil,
        systemImageName: String? = nil,
        highlightedSystemImageName: String? = nil,
        type: CryptogramKeyboardKeyType,
        canMagnify: Bool = false,
        isEnabled: Bool = true,
        isHidden: Bool = false,
        size: KeyboardButtonSize? = nil,
        styles: KeyboardButtonStyles? = nil,
        userInfo: [String: Any] = [:],
        systemSoundId: UInt32? = nil
    ) -> KeyboardKey {
        return KeyboardKey(
            text: text,
            imageName: imageName,
            highlightedImageName: highlightedImageName,
            systemImageName: systemImageName,
            highlightedSystemImageName: highlightedSystemImageName,
            type: type.rawValue,
            canMagnify: canMagnify,
            isEnabled: isEnabled,
            isHidden: isHidden,
            size: size,
            styles: styles,
            userInfo: userInfo,
            systemSoundId: systemSoundId
        )
    }

    static func character(
        _ character: String,
        size: KeyboardButtonSize? = nil,
        styles: KeyboardButtonStyles? = nil
    ) -> KeyboardKey {
        cryptogramKeyboardKey(
            text: character,
            type: .character,
            canMagnify: UIDevice.current.userInterfaceIdiom == .phone,
            size: size,
            styles: styles,
            systemSoundId: KeyboardSystemSound.click.rawValue
        )
    }

    static func next(size: KeyboardButtonSize? = nil, styles: KeyboardButtonStyles? = nil) -> KeyboardKey {
        cryptogramKeyboardKey(
            systemImageName: "chevron.right.2",
            type: .next,
            size: size,
            styles: styles,
            systemSoundId: KeyboardSystemSound.click.rawValue
        )
    }

    static func previous(size: KeyboardButtonSize? = nil, styles: KeyboardButtonStyles? = nil) -> KeyboardKey {
        cryptogramKeyboardKey(
            systemImageName: "chevron.left.2",
            type: .previous,
            size: size,
            styles: styles,
            systemSoundId: KeyboardSystemSound.click.rawValue
        )
    }
}
