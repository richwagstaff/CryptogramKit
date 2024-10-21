import Foundation

open class Wrapper<Element: BreakableElement> {
    public init() {}

    public func wrap(items: [Element], maxLength: Int, removeBreakPointsAtStartAndEndOfLines: Bool) -> [[Element]] {
        var rows: [[Element]] = []

        var row: [Element] = []
        var columnCount = 0

        for (i, item) in items.enumerated() {
            if columnCount == 0 && item.isBreakable {
                continue
            }

            row.append(item)
            columnCount += 1

            var addRow = false
            if item.isBreakable {
                let nextWordLength = items.lengthOfSegment(at: i + 1)
                if columnCount + nextWordLength >= maxLength {
                    addRow = true
                }
            }

            if columnCount >= maxLength {
                addRow = true
            }

            if addRow {
                if removeBreakPointsAtStartAndEndOfLines && row.last?.isBreakable == true {
                    row.removeLast()
                }

                rows.append(row)
                row = []
                columnCount = 0
            }
        }

        if !row.isEmpty {
            rows.append(row)
        }

        return rows
    }
}
