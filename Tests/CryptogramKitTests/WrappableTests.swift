@testable import CryptogramKit
import XCTest

final class WrappableTests: XCTestCase {
    // MARK: - Wrap Tests

    func testWrapShortTextWithMaxLength14() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let wrappedItems = items.wrap(maxLength: 14)

        XCTAssertEqual(wrappedItems.count, 4)
        XCTAssertEqual(wrappedItems[0].count, 13)
        XCTAssertEqual(wrappedItems[1].count, 11)
    }

    func testWrapLongTextWithMaxLength15() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "There has never been a sadness that can't be cured by breakfast food",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let wrappedItems = items.wrap(maxLength: 15)

        XCTAssertEqual(wrappedItems.count, 6)
        XCTAssertEqual(wrappedItems[5].count, 4)
    }

    func testWrapEmptyInput() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let wrappedItems = items.wrap(maxLength: 10)
        XCTAssertEqual(wrappedItems.count, 0)
    }

    /*
     func testWrapSingleLongWord() throws {
         let items = CellViewModelGenerator().viewModels(
             for: "Supercalifragilisticexpialidocious",
             solved: [],
             cipherMap: Cipher.generateNumberCipherMap()
         )

         let wrappedItems = items.wrap(maxLength: 10)
         XCTAssertEqual(wrappedItems.count, 1)
         XCTAssertEqual(wrappedItems[0].count, items.count)
     }*/

    func testWrapMaxLengthGreaterThanInputLength() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "Short text",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let wrappedItems = items.wrap(maxLength: 20)
        XCTAssertEqual(wrappedItems.count, 1)
        XCTAssertEqual(wrappedItems[0].count, items.count)
    }

    // MARK: - Segment Length Tests

    func testLengthOfSegmentsInShortText() throws {
        let viewModels = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        XCTAssertEqual(viewModels.lengthOfSegment(at: 0), 1)
        XCTAssertEqual(viewModels.lengthOfSegment(at: 2), 4)
        XCTAssertEqual(viewModels.lengthOfSegment(at: 10), 6)
    }

    func testLengthOfSegmentInLongText() throws {
        let viewModels = CellViewModelGenerator().viewModels(
            for: "There has never been a sadness that can't be cured by breakfast food",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        let length = viewModels.lengthOfSegment(at: 64)
        XCTAssertEqual(length, 4)
    }

    // MARK: - Segment Start Index Tests

    func testStartIndexOfSegmentInShortText() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 0), 0) // "I"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 2), 2) // "have"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 5), 2) // "have"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 12), 7) // "depended"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 43), 42) // "strangers"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 50), 42) // "strangers"
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: -1), nil) // out of bounds
        XCTAssertEqual(items.segmentStartIndex(forSegmentContainingIndex: 51), nil) // out of bounds
    }

    // MARK: - Segment End Index Tests

    func testEndIndexOfSegmentInShortText() throws {
        let items = CellViewModelGenerator().viewModels(
            for: "I have always depended on the kindness of strangers",
            solved: [],
            cipherMap: Cipher.generateNumberCipherMap()
        )

        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 0), 0) // "I"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 2), 5) // "have"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 5), 5) // "have"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 12), 12) // "always"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 43), 50) // "strangers"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 50), 50) // "strangers"
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: -1), nil) // out of bounds
        XCTAssertEqual(items.segmentEndIndex(forSegmentContainingIndex: 51), nil) // out of bounds
    }
}
