import Foundation

open class Wrapper<Element: SeparatorElement> {
    public init() {}

    public func wrapped2(items: [Element], maxLineLength: Int, lineBreakElement: Element) -> [[Element]] {
        var rows: [[Element]] = []
        var row: [Element] = []
        var segmentIndex = 0

        for (itemIndex, element) in items.enumerated() {
            if element.isSeparator {
                segmentIndex = 0

                if !row.isEmpty {
                    // Add separator element when there are other elements in the row
                    row.append(element)
                }

                continue
            }

            let segment = items.segment(at: itemIndex)

            if segment.count > maxLineLength {
                if row.count == maxLineLength - 1 {
                    row.append(lineBreakElement)
                    rows.append(row.trim())

                    row = [element]
                }
                else {
                    row.append(element)
                }
            }
            else if row.count + segment.count - segmentIndex <= maxLineLength {
                row.append(element)
            }
            else {
                rows.append(row.trim())
                row = [element]
            }

            segmentIndex += 1
        }

        if !row.isEmpty {
            rows.append(row.trim())
        }

        return rows
    }

    public func wrapped(items: [Element], maxLineLength: Int, trim: Bool, endOfLineWrappedElement: Element) -> [[Element]] {
        var rows: [[Element]] = []

        var row: [Element] = []
        var fastForward = 0

        for (i, item) in items.enumerated() {
            let columnCount = row.count

            if fastForward > columnCount {
                continue
            }

            if columnCount == 0 && item.isSeparator {
                continue
            }

            let nextWordLength = items.lengthOfSegment(at: i + 1)
            if nextWordLength >= maxLineLength {
                // Will not fit on one line, so split it up
                let remainingSpace = maxLineLength - columnCount
                items.splitSegment(at: i + 1, length: remainingSpace - 1).forEach { row.append($0) }
                row.append(endOfLineWrappedElement)

                row = items.splitSegment(at: remainingSpace, length: maxLineLength)
                fastForward = i + nextWordLength - 1
                continue
            }

            row.append(item)

            var addRow = false
            if item.isSeparator {
                let nextWordLength = items.lengthOfSegment(at: i + 1)
                if columnCount + nextWordLength >= maxLineLength {
                    addRow = true
                }
            }

            if columnCount >= maxLineLength {
                addRow = true
            }

            if addRow {
                if trim && row.last?.isSeparator == true && row.last?.isTrimmable == true {
                    row.removeLast()
                }

                let nextWordLength = items.lengthOfSegment(at: i + 1)
                if nextWordLength >= maxLineLength {
                    // Will not fit on one line, so split it up
                    let remainingSpace = maxLineLength - columnCount
                    items.splitSegment(at: i + 1, length: remainingSpace - 1).forEach { row.append($0) }
                    row.append(endOfLineWrappedElement)

                    row = items.splitSegment(at: remainingSpace, length: maxLineLength)
                    fastForward = i + nextWordLength - 1
                }
                else {
                    rows.append(row)
                    row = []
                }
            }
        }

        if !row.isEmpty {
            rows.append(row)
        }

        return rows
    }
}
