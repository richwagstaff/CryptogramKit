import Foundation

public protocol CryptogramRowHandling {
    var rows: [[CryptogramViewCellViewModelProtocol]] { get }
}

public extension CryptogramRowHandling {
    func item(at indexPath: CryptogramIndexPath) -> CryptogramViewCellViewModelProtocol? {
        guard rows.count > indexPath.row else {
            return nil
        }

        let row = rows[indexPath.row]
        guard row.count > indexPath.column else {
            return nil
        }

        return row[indexPath.column]
    }

    func indexPaths(for items: [CryptogramViewCellViewModelProtocol]) -> [CryptogramIndexPath] {
        indexPaths(whereIdIn: items.map { $0.id })
    }

    func indexPath(before indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        arrangedIndexPaths(startingAfter: indexPath, ascending: false).first
    }

    func indexPath(after indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        arrangedIndexPaths(startingAfter: indexPath, ascending: true).first
    }

    func firstSelectableIndexPath(after indexPath: CryptogramIndexPath, forward: Bool = true) -> CryptogramIndexPath? {
        let arrangedIndexPaths = arrangedIndexPaths(startingAfter: indexPath, ascending: true)

        return arrangedIndexPaths.first(where: { indexPath in
            let item = self.item(at: indexPath)
            return item?.isSelectable == true
        })
    }

    func firstEmptyIndexPath(after indexPath: CryptogramIndexPath, forward: Bool = true) -> CryptogramIndexPath? {
        let arrangedIndexPaths = arrangedIndexPaths(startingAfter: indexPath, ascending: forward)

        return arrangedIndexPaths.first(where: { indexPath in
            let item = self.item(at: indexPath)
            return item?.isFilled() == false && item?.isSelectable == true
        })
    }

    func firstEmptyIndexPath(before indexPath: CryptogramIndexPath) -> CryptogramIndexPath? {
        firstEmptyIndexPath(after: indexPath, forward: false)
    }

    func emptyIndexPaths() -> [CryptogramIndexPath] {
        indexPaths(where: { $0.isFilled() == false && $0.isSelectable == true })
    }

    func allIndexPaths() -> [CryptogramIndexPath] {
        var indexPaths: [CryptogramIndexPath] = []

        for (rowIndex, row) in rows.enumerated() {
            for columnIndex in 0 ..< row.count {
                let indexPath = CryptogramIndexPath(row: rowIndex, column: columnIndex)
                indexPaths.append(indexPath)
            }
        }

        return indexPaths
    }

    func arrangedIndexPaths(startingAt indexPath: CryptogramIndexPath, ascending: Bool = true) -> [CryptogramIndexPath] {
        let indexPaths = allIndexPaths()
        let sortedIndexPaths = ascending ? indexPaths : indexPaths.reversed()

        guard let startIndex = sortedIndexPaths.firstIndex(of: indexPath) else { return indexPaths }
        let arrangedIndexPaths = sortedIndexPaths[startIndex ..< sortedIndexPaths.count] + sortedIndexPaths[0 ..< startIndex]
        return Array(arrangedIndexPaths)
    }

    func arrangedIndexPaths(startingAfter indexPath: CryptogramIndexPath, ascending: Bool = true) -> [CryptogramIndexPath] {
        let indexPaths = arrangedIndexPaths(startingAt: indexPath, ascending: ascending)

        // Move first to last position
        guard let first = indexPaths.first else { return indexPaths }
        var arrangedIndexPaths = Array(indexPaths.dropFirst())
        arrangedIndexPaths.append(first)
        return arrangedIndexPaths
    }

    func indexPathIterator(startingAt indexPath: CryptogramIndexPath? = nil, ascending: Bool = true) -> AnyIterator<CryptogramIndexPath> {
        let indexPath = indexPath ?? CryptogramIndexPath(row: 0, column: 0)
        let indexPaths = arrangedIndexPaths(startingAt: indexPath, ascending: ascending)
        var index = 0

        return AnyIterator {
            guard index < indexPaths.count else { return nil }
            defer { index += 1 }
            return indexPaths[index]
        }
    }

    func indexPaths(where predicate: (CryptogramViewCellViewModelProtocol) -> Bool) -> [CryptogramIndexPath] {
        var indexPaths: [CryptogramIndexPath] = []

        for path in indexPathIterator() {
            guard let item = item(at: path) else { continue }
            if predicate(item) {
                indexPaths.append(path)
            }
        }

        return indexPaths
    }

    func firstIndexPath(whereId id: UUID) -> CryptogramIndexPath? {
        indexPaths(where: { $0.id == id }).first
    }

    func indexPaths(whereIdIn ids: [UUID]) -> [CryptogramIndexPath] {
        indexPaths(where: { item in
            ids.contains(where: { $0 == item.id })
        })
    }
}
