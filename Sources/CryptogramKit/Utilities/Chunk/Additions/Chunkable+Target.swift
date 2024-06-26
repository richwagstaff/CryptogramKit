
import Foundation

public extension Array where Element: Chunkable {
    func chunk(targetChunkSize: Int, deleteLastElementInChunkIfBreakPoint: Bool = true) -> [[Element]] {
        TargetChunker<Element>().chunk(
            items: self,
            maxChunkSize: targetChunkSize,
            deleteLastElementInChunkIfBreakPoint: deleteLastElementInChunkIfBreakPoint
        )
    }
}
