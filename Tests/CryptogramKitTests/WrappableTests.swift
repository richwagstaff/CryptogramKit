@testable import CryptogramKit
import XCTest

extension Character: SeparatorElement {
    public var isSeparator: Bool {
        return self == " " || self == "-"
    }

    public var isTrimmable: Bool {
        return self == " "
    }
}

extension String {
    func wrap(maxLineLength: Int) -> [[Character]] {
        Array(self).wrapped(maxLineLength: maxLineLength, lineBreakElement: "-")
    }
}

final class WrappableTests: XCTestCase {
    // MARK: - Wrap Tests

    func testWrapShortTextWithMaxLength14() throws {
        let wrappedItems = "I have always depended on the kindness of strangers".wrap(maxLineLength: 14)

        XCTAssertEqual(wrappedItems.count, 4)
        XCTAssertEqual(wrappedItems[0].count, 13)
        XCTAssertEqual(wrappedItems[1].count, 11)
    }

    func testWrapLongTextWithMaxLength15() throws {
        let wrappedItems = "There has never been a sadness that can't be cured by breakfast food".wrap(maxLineLength: 15)

        XCTAssertEqual(wrappedItems.count, 5)
        XCTAssertEqual(wrappedItems[4].count, 14)
    }

    func testWrapEmptyInput() throws {
        let wrappedItems = "".wrap(maxLineLength: 10)
        XCTAssertEqual(wrappedItems.count, 0)
    }

    func testWrapSingleLongWord() throws {
        let wrappedItems = "Supercalifragilisticexpialidocious".wrap(maxLineLength: 10)
        XCTAssertEqual(wrappedItems.count, 4)
        XCTAssertEqual(wrappedItems[0].count, 10)
        XCTAssertEqual(wrappedItems[3].count, 7)
    }

    func testWrapMaxLengthGreaterThanInputLength() throws {
        let wrappedItems = "Short text".wrap(maxLineLength: 20)
        XCTAssertEqual(wrappedItems.count, 1)
        XCTAssertEqual(wrappedItems[0].count, 10)
    }

    // MARK: - Segment Length Tests

    func testLengthOfSegmentsInShortText() throws {
        let items = Array("I have always depended on the kindness of strangers")

        XCTAssertEqual(items.lengthOfSegment(at: 0), 1)
        XCTAssertEqual(items.lengthOfSegment(at: 2), 4)
        XCTAssertEqual(items.lengthOfSegment(at: 10), 6)
    }

    func testLengthOfSegmentInLongText() throws {
        let items = Array("There has never been a sadness that can't be cured by breakfast food")
        let length = items.lengthOfSegment(at: 64)
        XCTAssertEqual(length, 4)
    }

    // MARK: - Segment Start Index Tests

    func testStartIndexOfSegmentInShortText() throws {
        let items = Array("I have always depended on the kindness of strangers")

        XCTAssertEqual(items.startIndexOfSegment(containing: 0), 0) // "I"
        XCTAssertEqual(items.startIndexOfSegment(containing: 2), 2) // "have"
        XCTAssertEqual(items.startIndexOfSegment(containing: 5), 2) // "have"
        XCTAssertEqual(items.startIndexOfSegment(containing: 12), 7) // "depended"
        XCTAssertEqual(items.startIndexOfSegment(containing: 43), 42) // "strangers"
        XCTAssertEqual(items.startIndexOfSegment(containing: 50), 42) // "strangers"
        XCTAssertEqual(items.startIndexOfSegment(containing: -1), nil) // out of bounds
        XCTAssertEqual(items.startIndexOfSegment(containing: 51), nil) // out of bounds
    }

    // MARK: - Segment End Index Tests

    func testEndIndexOfSegmentInShortText() throws {
        let items = Array("I have always depended on the kindness of strangers")

        XCTAssertEqual(items.endIndexOfSegment(containing: 0), 0) // "I"
        XCTAssertEqual(items.endIndexOfSegment(containing: 2), 5) // "have"
        XCTAssertEqual(items.endIndexOfSegment(containing: 5), 5) // "have"
        XCTAssertEqual(items.endIndexOfSegment(containing: 12), 12) // "always"
        XCTAssertEqual(items.endIndexOfSegment(containing: 43), 50) // "strangers"
        XCTAssertEqual(items.endIndexOfSegment(containing: 50), 50) // "strangers"
        XCTAssertEqual(items.endIndexOfSegment(containing: -1), nil) // out of bounds
        XCTAssertEqual(items.endIndexOfSegment(containing: 51), nil) // out of bounds
    }
}
