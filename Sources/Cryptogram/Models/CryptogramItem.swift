import Foundation

public struct CryptogramItem {
    public var id: Int
    public var letter: String
    public var code: String
    public var selectable: Bool
    public var type: CryptogramItemType

    public init(id: Int, letter: String, code: String, selectable: Bool, type: CryptogramItemType) {
        self.id = id
        self.letter = letter
        self.code = code
        self.selectable = selectable
        self.type = type
    }
}
