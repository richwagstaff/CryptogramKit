
import Foundation

public protocol SeparatorElement {
    /// Whether this is a point where the element can be broken
    var isSeparator: Bool { get }

    /// Whether this element can be trimmed
    var isTrimmable: Bool { get }
}
