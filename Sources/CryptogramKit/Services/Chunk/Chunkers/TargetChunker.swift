import Foundation

open class TargetChunker<ChunkElement: Chunkable> {
    public typealias Element = ChunkElement
    public init() {}

    public func chunk(items: [ChunkElement], maxChunkSize: Int, deleteLastElementInChunkIfBreakPoint: Bool) -> [[ChunkElement]] {
        var rows: [[ChunkElement]] = []

        var row: [ChunkElement] = []
        var columnCount = 0

        for (i, item) in items.enumerated() {
            row.append(item)
            columnCount += 1

            var addRow = false
            if item.isBreakPoint {
                let nextWordLength = items.lengthOfSegment(at: i + 1)
                if columnCount + nextWordLength >= maxChunkSize {
                    addRow = true
                }
            }

            if columnCount >= maxChunkSize {
                addRow = true
            }

            if addRow {
                if deleteLastElementInChunkIfBreakPoint && row.last?.isBreakPoint == true {
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
