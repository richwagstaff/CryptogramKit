import Foundation
import QuartzCore

protocol CryptogramAnimationProvider {
    func createSelectionAnimation() -> CAAnimation
    func createDeselectionAnimation() -> CAAnimation
    func createCodeSolvedAnimation() -> CAAnimation
}
