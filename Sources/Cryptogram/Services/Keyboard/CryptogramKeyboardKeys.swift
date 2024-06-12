import KeyboardKit
import UIKit

class CryptogramKeyboardKeys: KeyboardKeys {
    var disabledKeys: [String]?

    init(disabledKeys: [String]? = nil) {
        self.disabledKeys = disabledKeys
    }

    func rowTypes(keyboardView: KeyboardView) -> [KeyboardRowType] {
        return [.qwerty, .asdf, .zxcv]
    }

    func createRow(rowType: KeyboardRowType, keyboardView: KeyboardView) -> KeyboardRow {
        let row = generator(keyboardView).row(for: rowType)

        if let disabledKeys = disabledKeys {
            disableKeysInRow(row, keysToDisable: disabledKeys)
        }

        return row
    }

    func disableKeysInRow(_ row: KeyboardRow, keysToDisable: [String]) {
        guard !keysToDisable.isEmpty else { return }

        // Modify the row to disable keys
        for (section, viewModels) in row.itemsDict {
            for (index, viewModel) in viewModels.enumerated() {
                guard let text = viewModel.keyboardKey.text else { continue }
                if keysToDisable.contains(text) {
                    var viewModel = viewModel
                    viewModel.keyboardKey.isEnabled = false
                    row.replaceItem(with: viewModel, at: index, section: section)
                }
            }
        }
    }

    func generator(_ keyboardView: KeyboardView) -> KeyboardRowGenerating {
        return CryptogramKeyboardRowGenerator(
            config: keyboardView.getConfigBasedOnWidth()
        )
    }

    func keyboardMargin(keyboardView: KeyboardView) -> UIEdgeInsets {
        return .automaticKeyboardMargin
    }

    func keyHeight(rowType: KeyboardKit.KeyboardRowType, keyboardView: KeyboardKit.KeyboardView) -> CGFloat {
        return .automaticKeyHeight
    }

    func keyMargin(keyboardView: KeyboardKit.KeyboardView) -> UIEdgeInsets {
        return .automaticKeyMargin
    }
}
