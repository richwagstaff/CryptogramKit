import Foundation

open class CryptogramItem: ObservableObject {
    public var id = UUID()
    public var value: String
    public var correctValue: String
    public var code: String
    public var selectable: Bool
    public var inputtedAt: Date?
    public var type: CryptogramItemType

    public init(id: UUID = UUID(), value: String, correctValue: String, code: String, selectable: Bool, inputtedAt: Date? = nil, type: CryptogramItemType) {
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
        return correctValue == value
    }
}
