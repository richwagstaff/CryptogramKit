import Foundation

public struct CryptogramItem {
    public var id: Int
    public var value: String
    public var correctValue: String
    public var code: String
    public var selectable: Bool
    public var inputtedAt: Date?
    public var type: CryptogramItemType

    public init(id: Int, value: String, correctValue: String, code: String, selectable: Bool, inputtedAt: Date? = nil, type: CryptogramItemType) {
        self.id = id
        self.value = value
        self.correctValue = correctValue
        self.code = code
        self.selectable = selectable
        self.inputtedAt = inputtedAt
        self.type = type
    }
}
