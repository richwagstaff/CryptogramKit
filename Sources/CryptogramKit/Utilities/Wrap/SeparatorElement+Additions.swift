
import Foundation

public extension Array where Element: SeparatorElement {
    func wrapped(maxLineLength: Int, lineBreakElement: Element) -> [[Element]] {
        Wrapper<Element>().wrapped2(
            items: self,
            maxLineLength: maxLineLength,
            lineBreakElement: lineBreakElement
        )
    }

    func startIndexOfSegment(containing index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }

        if self[index].isSeparator {
            return index
        }

        var i = index

        while i >= 0 {
            if self[i].isSeparator {
                return i + 1
            }

            i -= 1
        }

        return 0
    }

    func endIndexOfSegment(containing index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }

        if self[index].isSeparator {
            return index
        }

        var i = index

        while i < count {
            if self[i].isSeparator {
                return i - 1
            }

            i += 1
        }

        return count - 1
    }

    func lengthOfSegment(at index: Int) -> Int {
        if index >= count {
            return 0
        }

        if self[index].isSeparator {
            return 0
        }

        guard
            let startIndex = startIndexOfSegment(containing: index),
            let endIndex = endIndexOfSegment(containing: index)
        else {
            return 0
        }

        return endIndex - startIndex + 1
    }

    func trim() -> [Element] {
        var items = self

        while let last = items.last, last.isSeparator && last.isTrimmable {
            items.removeLast()
        }

        return items
    }

    func segment(at index: Int) -> [Element] {
        guard
            let startIndex = startIndexOfSegment(containing: index),
            let endIndex = endIndexOfSegment(containing: index)
        else {
            return []
        }

        return Array(self[startIndex ... endIndex])
    }

    func splitSegment(at index: Int, length: Int) -> [Element] {
        let segment = self.segment(at: index)

        if length >= segment.count {
            return segment
        }

        return Array(segment[0 ..< length])
    }

    func split(includeSeparators: Bool = false) -> [[Element]] {
        var rows: [[Element]] = []
        var row: [Element] = []

        for item in self {
            if item.isSeparator {
                if includeSeparators {
                    row.append(item)
                }

                rows.append(row)
                row = []
            }
            else {
                row.append(item)
            }
        }

        rows.append(row)

        return rows
    }
}
