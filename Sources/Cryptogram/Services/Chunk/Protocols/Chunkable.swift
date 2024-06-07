
import Foundation

public protocol Chunkable {
    /// Whether this is a point where the chunk can be broken
    var isBreakPoint: Bool { get }
}

public extension Array where Element: Chunkable {
    func lengthOfSegment(at index: Int) -> Int {
        if index >= count {
            return 0
        }

        if self[index].isBreakPoint {
            return 0
        }

        var i = 0
        var previousBreakPointIndex = -1
        while i < count {
            if self[i].isBreakPoint {
                previousBreakPointIndex = i
            }

            if i == index {
                break
            }

            i += 1
        }

        var nextBreakPointIndex = previousBreakPointIndex + 1
        while i < count {
            if self[i].isBreakPoint {
                nextBreakPointIndex = i
                break
            }

            i += 1
        }

        return nextBreakPointIndex - previousBreakPointIndex - 1
    }
}
