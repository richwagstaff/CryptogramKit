
import Foundation

public protocol BreakableElement {
    /// Whether this is a point where the element can be broken
    var isBreakable: Bool { get }
}

public extension Array where Element: BreakableElement {
    func segmentStartIndex(forSegmentContainingIndex index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }

        var i = index

        while i >= 0 {
            if self[i].isBreakable {
                return i + 1
            }

            i -= 1
        }

        return 0
    }

    func segmentEndIndex(forSegmentContainingIndex index: Int) -> Int? {
        guard index >= 0 && index < count else { return nil }

        var i = index

        while i < count {
            if self[i].isBreakable {
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

        if self[index].isBreakable {
            return 0
        }

        guard
            let startIndex = segmentStartIndex(forSegmentContainingIndex: index),
            let endIndex = segmentEndIndex(forSegmentContainingIndex: index)
        else {
            return 0
        }

        return endIndex - startIndex + 1
    }
}
