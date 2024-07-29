import Foundation

public extension Sequence where Element: CryptogramItem {
    private var allCodes: [String] {
        filter { !$0.code.isEmpty }.map { $0.code }
    }

    func codes(forState state: CryptogramCodeSolutionState) -> Set<String> {
        switch state {
        case .fullySolved:
            return fullySolvedCodes()
        case .partiallySolved:
            return partiallySolvedCodes()
        case .unsolved:
            return unsolvedCodes()
        }
    }

    func fullySolvedCodes() -> Set<String> {
        var codes = Set(allCodes)

        for item in self {
            if !item.isCorrect {
                codes.remove(item.code)
            }
        }

        return codes
    }

    func partiallySolvedCodes() -> Set<String> {
        var codes = Set<String>()

        for item in self {
            if item.isCorrect {
                codes.insert(item.code)
            }
        }

        let fullySolvedCodes = fullySolvedCodes()

        return codes.subtracting(fullySolvedCodes)
    }

    func unsolvedCodes() -> Set<String> {
        var solvedCodes = fullySolvedCodes()
        solvedCodes.formUnion(partiallySolvedCodes())

        return Set(allCodes).subtracting(solvedCodes)
    }

    func characters(state: CryptogramCodeSolutionState, cipherMap: [String: String]) -> [String] {
        let codes = codes(forState: state)
        return codes.compactMap { cipherMap[$0] }
    }
}
