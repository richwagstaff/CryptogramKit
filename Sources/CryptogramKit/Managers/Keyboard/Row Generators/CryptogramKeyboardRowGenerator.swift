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

    func row(for type: KeyboardRowType) -> KeyboardRow {
        return generator(for: type).row(for: type)
    }

    func generator(for rowType: KeyboardRowType) -> KeyboardRowGenerating {
        if let largeConfig = config as? LargeKeyboardConfiguration {
            return largeKeyboardGenerator(config: largeConfig)
        }
        else {
            return compactKeyboardGenerator()
        }
    }

    func compactKeyboardGenerator() -> KeyboardRowGenerating {
        return CompactCryptogramKeyboardRowGenerator(
            config: config,
            sizes: sizes,
            styles: styles
        )
    }

    func largeKeyboardGenerator(config: LargeKeyboardConfiguration) -> KeyboardRowGenerating {
        return LargeCryptogramKeyboardRowGenerator(
            config: config,
            sizes: sizes,
            styles: styles
        )
    }
}
