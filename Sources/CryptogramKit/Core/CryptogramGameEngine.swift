import Combine
import Foundation

open class CryptogramGameEngine: ObservableObject {
    public weak var delegate: CryptogramGameEngineDelegate?

    @Published public var items: [CryptogramItem] = []
    @Published public var livesRemaining: Int = 2
    @Published public var maxLives: Int = 4
    @Published public var state: CryptogramGameState = .active
    @Published public var valuesFound: [String] = []
    @Published public var isPlaying: Bool = false
    @Published public var isPaused: Bool = false
    @Published public var time: TimeInterval = 0

    private var startedAt: Date?
    private var pausedAt: Date?

    init(items: [CryptogramItem], lives: Int = 4, maxLives: Int = 4, valuesFound: [String] = []) {
        self.items = items
        self.livesRemaining = lives
        self.maxLives = maxLives
        self.valuesFound = valuesFound

        updateGameState()
    }

    @discardableResult
    open func makeAttempt(value: String, forItemWithId id: String) -> Bool {
        guard let item = items.first(where: { $0.id == id }) else { return false }

        let success = item.isCorrect(value)
        if success {
            revealAllItemsWithCode(item.code)
        }
        else {
            handleWrongAnswerInputted(value)
        }

        updateGameState()

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

    open func didCompleteGame() {
        stop()
        delegate?.gameDidFinish(engine: self, success: true)
    }

    open func didFailGame() {
        stop()
        delegate?.gameDidFinish(engine: self, success: false)
    }

    func setValue(_ value: String, forItemAt index: Int, updateInputtedAt: Bool) {
        guard index < items.count else { return }
        items[index].setValue(value, updateInputtedAt: updateInputtedAt)
    }

    open func revealAllItemsWithCode(_ code: String) {
        let items = items.filter { $0.code == code }

        for item in items {
            item.setValue(item.correctValue, updateInputtedAt: true)
        }

        delegate?.didInputAnswers(into: items, engine: self)
    }

    open func revealAllRemainingItems(staggered: Bool = false, completion: (() -> Void)?) {
        let items = items.filter { $0.value != $0.correctValue }

        for (index, item) in items.enumerated() {
            let delay = staggered ? Double(index) * 0.2 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                item.setValue(item.correctValue, updateInputtedAt: true)

                if staggered {
                    self.delegate?.didInputAnswers(into: [item], engine: self)
                }

                if index == items.count - 1 {
                    completion?()
                }
            }
        }

        if !staggered {
            delegate?.didInputAnswers(into: items, engine: self)
        }
    }

    open func handleWrongAnswerInputted(_ value: String) {
        removeLife()
        delegate?.wrongAnswerInputted(engine: self)
    }

    open func isCompleted() -> Bool {
        items.allSatisfy { $0.value == $0.correctValue }
    }

    public func timeElapsed() -> TimeInterval {
        guard let startedAt = startedAt else { return time }
        return time + Date().timeIntervalSince(startedAt)
    }

    public func start() {
        startedAt = Date()
        isPlaying = true
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

    /* open func attempt(value: String, forItemWithId id: Int) {
         guard let index = items.firstIndex(where: { $0.id == id }) else { return }

         let item = items[index]
         if item.value == item.correctValue {
             items[index].value = value
             revealItemValuesForCode(item.code)

             if isCompleted() {
                 delegate?.gameDidComplete(gameController: self)
             }
         }
         else {
             attemptDidFail()
         }

         /*  guard
              let indexPath = cryptogramView.selectedIndexPath,
              let cell = cryptogramView.cell(at: indexPath),
              let viewModel = item(at: indexPath)
          else { return }

          if viewModel.isCorrectValue(character) {
              viewModel.setValue(character, cell: cell, in: cryptogramView)

              let remainingIndexPaths = selectionManager.indexPaths(where: { item in
                  item.isAssociated(with: viewModel)
              })

              for indexPath in remainingIndexPaths {
                  guard let viewModel = item(at: indexPath) else { continue }
                  viewModel.fill()
              }

              cryptogramView.reloadCells(at: remainingIndexPaths)

              delegate?.cryptogramViewManager(self, didModifyItemAt: indexPath, in: cryptogramView)

              deselectHighlightedCells(in: cryptogramView)
              selectNextCell(in: cryptogramView)

              if isCompleted() {
                  delegate?.cryptogramViewManager(self, didComplete: cryptogramView)
                  deselectCell(in: cryptogramView)
              }
          }
          else {
              delegate?.cryptogramViewManager(self, didInputWrongAnswerAt: indexPath, in: cryptogramView)
          }*/
     }*/

    /* // MARK: - Cryptogram Manager Delegate

     public func cryptogramViewManager(_ manager: CryptogramViewManager, didModifyItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         guard let value = manager.item(at: indexPath)?.value else { return }
         correctAnswerInputted(at: indexPath, value: value)
     }

     public func cryptogramViewManager(_ manager: CryptogramViewManager, didSelectItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         print("Did select item at \(indexPath)")
     }

     public func cryptogramViewManager(_ manager: CryptogramViewManager, didInputWrongAnswerAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
         wrongAnswerInputted()
     }

     public func cryptogramViewManager(_ manager: CryptogramViewManager, didComplete cryptogramView: CryptogramView) {
         didCompleteGame()
     }*/
}
