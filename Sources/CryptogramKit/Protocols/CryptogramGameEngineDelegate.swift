import Foundation

public protocol CryptogramGameEngineDelegate: AnyObject {
    func wrongAnswerInputted(engine: CryptogramGameEngine)
    func gameDidFinish(engine: CryptogramGameEngine, success: Bool)
    func didInputAnswers(into items: [CryptogramItem], engine: CryptogramGameEngine)
}
