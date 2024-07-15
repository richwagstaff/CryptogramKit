import Foundation

open class CryptogramItem: ObservableObject {
    public var id: String
    public var value: String
    public var correctValue: String
    public var code: String
    public var selectable: Bool
    public var inputtedAt: Date?
    public var type: CryptogramItemType
    public var caseSensitive: Bool = false

    public init(id: String, value: String, correctValue: String, code: String, selectable: Bool, inputtedAt: Date?, type: CryptogramItemType) {
        self.id = id
        self.value = value
        self.correctValue = correctValue
        self.code = code
        self.selectable = selectable
        self.inputtedAt = inputtedAt
        self.type = type
    }

    public func setValue(_ value: String, updateInputtedAt: Bool) {
        self.value = value
        if updateInputtedAt {
            inputtedAt = Date()
        }

        objectWillChange.send()
    }

    open func isCorrect(_ value: String) -> Bool {
        if caseSensitive {
            return correctValue == value
        }
        else {
            return correctValue.lowercased() == value.lowercased()
        }
    }

    open func isFillable() -> Bool {
        type == .letter
    }

    public var isCorrect: Bool {
        return isCorrect(value)
    }
}
