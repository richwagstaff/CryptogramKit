import Foundation

public protocol CryptogramGameEngineDelegate: AnyObject {
    func wrongAnswerInputted(engine: CryptogramGameEngine)
    func gameDidBegin(engine: CryptogramGameEngine)
    func gameDidFinish(engine: CryptogramGameEngine)
    func didInputAnswers(into items: [CryptogramItem], engine: CryptogramGameEngine)
    func didSolveCode(_ code: String, engine: CryptogramGameEngine)
}
