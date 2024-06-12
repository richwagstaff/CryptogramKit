import KeyboardKit
import UIKit

class CryptogramKeyboardRowGenerator: KeyboardRowGenerating {
    var config: KeyboardConfiguration
    var sizes: KeyboardConfigButtonSizes
    var styles: KeyboardConfigButtonStyles

    init(
        config: KeyboardConfiguration,
        sizes: KeyboardConfigButtonSizes? = nil,
        styles: KeyboardConfigButtonStyles? = nil
    ) {
        self.config = config
        self.sizes = sizes ?? config.buttonSizes
        self.styles = styles ?? config.buttonStyles
    }

    func row(for type: KeyboardKit.KeyboardRowType) -> KeyboardRow {
        return compactKeyboardGenerator().row(for: type)
    }

    func compactKeyboardGenerator() -> KeyboardRowGenerating {
        return CompactCryptogramKeyboardRowGenerator(
            config: config,
            sizes: sizes,
            styles: styles
        )
    }

    func largeKeyboardGenerator(config: LargeKeyboardConfiguration) -> KeyboardRowGenerating {
        return CompactCryptogramKeyboardRowGenerator(
            config: config,
            sizes: sizes,
            styles: styles
        )
    }
}
