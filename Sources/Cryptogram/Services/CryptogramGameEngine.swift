import Combine
import Foundation

public protocol CryptogramGameEngineDelegate: AnyObject {
    func correctAnswerInputted(at indexPath: CryptogramIndexPath, value: String, engine: CryptogramGameEngine)
    func wrongAnswerInputted(at indexPath: CryptogramIndexPath, engine: CryptogramGameEngine)
    func livesDidChange(to lives: Int, enging: CryptogramGameEngine)
    func gameDidComplete(engine: CryptogramGameEngine)
    func didInputAnswers(into items: [CryptogramItem], engine: CryptogramGameEngine)
}

public enum CryptogramGameState {
    case active
    case completed
    case failed
}

open class CryptogramGameEngine: ObservableObject {
    public weak var delegate: CryptogramGameEngineDelegate?

    @Published public var items: [CryptogramItem] = []
    @Published public var lives: Int = 3
    @Published public var state: CryptogramGameState = .active
    @Published public var valuesFound: [String] = []

    init(items: [CryptogramItem], lives: Int = 3, valuesFound: [String] = []) {
        self.items = items
        self.lives = lives
        self.valuesFound = valuesFound

        updateGameState()
    }

    @discardableResult
    open func makeAttempt(value: String, forItemWithId id: UUID) -> Bool {
        guard let item = items.first(where: { $0.id == id }) else { return false }

        let success = item.isCorrect(value)
        if success {
            revealAllItemsWithCode(item.code)
        }
        else {
            removeLife()
        }

        updateGameState()

        return success
    }

    open func handleAttemptResult(on item: CryptogramItem, success: Bool) {
        if success {}
        else {
            lives -= 1
        }
    }

    open func removeLife() {
        lives -= 1
    }

    open func updateGameState() {
        state = determineGameState()
    }

    open func determineGameState() -> CryptogramGameState {
        if lives == 0 {
            return .failed
        }
        else if isCompleted() {
            return .completed
        }
        else {
            return .active
        }
    }

    open func didCompleteGame(on item: CryptogramItem) {
        delegate?.gameDidComplete(engine: self)
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

    open func isCompleted() -> Bool {
        items.allSatisfy { $0.value == $0.correctValue }
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
