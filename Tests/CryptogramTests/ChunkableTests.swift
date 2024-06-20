@testable import Cryptogram
import XCTest

final class ChunkableTests: XCTestCase {
    func testTargetChunk() throws {
        let viewModels = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            revealed: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let chunks = viewModels.chunk(targetChunkSize: 14)

        XCTAssertEqual(chunks.count, 4)
        XCTAssertEqual(chunks[0].count, 13)
        XCTAssertEqual(chunks[1].count, 11)
    }

    func testLengthOfSegment() throws {
        let viewModels = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            revealed: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let segment1Length = viewModels.lengthOfSegment(at: 0)
        let segment2Length = viewModels.lengthOfSegment(at: 2)
        let segment3Length = viewModels.lengthOfSegment(at: 10)

        XCTAssertEqual(segment1Length, 1)
        XCTAssertEqual(segment2Length, 4)
        XCTAssertEqual(segment3Length, 6)
    }
}
