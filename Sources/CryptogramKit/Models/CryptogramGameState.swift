import Foundation

public enum CryptogramGameState {
    case active
    case completed
    case failed

    var isFinished: Bool {
        self == .completed || self == .failed
    }

    var hasFailed: Bool {
        self == .failed
    }
}
