import Foundation
import KeyboardKit

public enum CryptogramKeyboardKeyType: String {
    case character
    case next
    case previous
}

public extension KeyboardKey {
    var cryptogramKeyType: CryptogramKeyboardKeyType? {
        return CryptogramKeyboardKeyType(rawValue: type)
    }
}
