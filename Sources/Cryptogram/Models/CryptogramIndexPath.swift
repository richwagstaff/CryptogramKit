

import Foundation

public struct CryptogramIndexPath: Hashable, Equatable {
    let row: Int
    let column: Int

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    public static func == (lhs: CryptogramIndexPath, rhs: CryptogramIndexPath) -> Bool {
        lhs.row == rhs.row && lhs.column == rhs.column
    }
}
