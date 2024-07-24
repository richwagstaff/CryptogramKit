import Foundation

public extension Sequence where Element: CryptogramItem {
    func solvedCodes() -> Set<String> {
        let allCodes = filter { !$0.code.isEmpty }.map { $0.code }
        var solved = Set(allCodes)

        for item in self {
            if !item.isCorrect {
                solved.remove(item.code)
            }
        }

        return solved
    }

    func solvedCharacters(cipherMap: [String: String]) -> [String] {
        let codes = solvedCodes()
        return codes.compactMap { cipherMap[$0] }
    }
}
