import Combine
import Foundation

open class CryptogramGameEngine: ObservableObject {
    public weak var delegate: CryptogramGameEngineDelegate?

    @Published public var items: [CryptogramItem] = [] {
        didSet {
            updateGameState()
            updateSolvedCodes()
        }
    }

    @Published public var livesRemaining: Int = 2
    @Published public var maxLives: Int = 4
    @Published public var state: CryptogramGameState = .active
    @Published public var solvedCodes: Set<String> = []
    @Published public var isPlaying: Bool = false
    @Published public var isPaused: Bool = false
    @Published public var time: TimeInterval = 0

    public var hideCodesWhenSolved = true

    private var startedAt: Date?
    private var pausedAt: Date?

    init(items: [CryptogramItem], lives: Int = 4, maxLives: Int = 4) {
        self.items = items
        self.livesRemaining = lives
        self.maxLives = maxLives

        updateGameState()
        updateSolvedCodes()
    }

    @discardableResult
    open func makeAttempt(value: String, forItemWithId id: String) -> Bool {
        guard let item = items.first(where: { $0.id == id }) else { return false }

        let success = item.isCorrect(value)
        if success {
            item.setValue(item.correctValue, updateInputtedAt: true)
            delegate?.didInputAnswers(into: [item], engine: self)
        }
        else {
            handleWrongAnswerInputted(value)
        }

        updateGameState()
        updateSolvedCodes()

        return success
    }

    open func handleAttemptResult(on item: CryptogramItem, success: Bool) {
        if !success {
            livesRemaining -= 1
        }
    }

    open func removeLife() {
        livesRemaining -= 1
        updateGameState()
    }

    open func updateGameState() {
        let stateBefore = state
        state = determineGameState()

        guard stateBefore != state else { return }

        if state == .completed {
            didCompleteGame()
        }
        else if state == .failed {
            didFailGame()
        }
    }

    open func determineGameState() -> CryptogramGameState {
        if livesRemaining == 0 {
            return .failed
        }
        else if isCompleted() {
            return .completed
        }
        else {
            return .active
        }
    }

    open func didBeginGame() {
        delegate?.gameDidBegin(engine: self)
    }

    open func didCompleteGame() {
        stop()
        delegate?.gameDidFinish(engine: self)
    }

    open func didFailGame() {
        stop()
        delegate?.gameDidFinish(engine: self)
    }

    func setValue(_ value: String, forItemAt index: Int, updateInputtedAt: Bool) {
        guard index < items.count else { return }
        items[index].setValue(value, updateInputtedAt: updateInputtedAt)
    }

    @discardableResult open func revealCorrectAnswers(callDelegate: Bool = true) -> [CryptogramItem] {
        let invalidItems = items.filter { $0.isFillable() && $0.value != $0.correctValue }

        invalidItems.forEach { item in
            item.setValue(item.correctValue, updateInputtedAt: true)
        }

        if callDelegate {
            delegate?.didInputAnswers(into: invalidItems, engine: self)
        }

        return invalidItems
    }

    open func updateSolvedCodes() {
        let previousSolvedCodes = solvedCodes

        solvedCodes = items.codes(forState: .fullySolved)

        if hideCodesWhenSolved {
            for item in items {
                if !item.codeHidden && solvedCodes.contains(item.code) {
                    item.setCodeHidden(true)
                }
            }
        }

        if previousSolvedCodes != solvedCodes {
            let newlySolvedCodes = solvedCodes.filter { !previousSolvedCodes.contains($0) }
            for code in newlySolvedCodes {
                delegate?.didSolveCode(code, engine: self)
            }
        }
    }

    open func handleWrongAnswerInputted(_ value: String) {
        removeLife()
        delegate?.wrongAnswerInputted(engine: self)
    }

    open func isCompleted() -> Bool {
        return items.filter { $0.type == .letter }.allSatisfy { $0.isCorrect }
    }

    public func timeElapsed() -> TimeInterval {
        guard let startedAt = startedAt else { return time }
        return time + Date().timeIntervalSince(startedAt)
    }

    public func start() {
        guard !isPlaying && !state.isFinished else { return }

        startedAt = Date()
        isPlaying = true

        didBeginGame()
    }

    public func stop() {
        time = timeElapsed()
        startedAt = nil
        pausedAt = nil
        isPlaying = false
        isPaused = false
    }

    public func pause() {
        time = timeElapsed()
        startedAt = nil

        pausedAt = Date()
        isPaused = true
    }

    public func resume() {
        startedAt = Date()
        pausedAt = nil
        isPaused = false
    }
}
