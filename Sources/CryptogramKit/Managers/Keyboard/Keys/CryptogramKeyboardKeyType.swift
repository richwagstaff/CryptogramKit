import Foundation
import KeyboardKit

public enum CryptogramKeyboardKeyType: String {
    case character
    case next
    case previous
    case blank
}

public extension KeyboardKey {
    var cryptogramKeyType: CryptogramKeyboardKeyType? {
        return CryptogramKeyboardKeyType(rawValue: type)
    }
}
