import Foundation
import QuartzCore

protocol CryptogramAnimationProvider {
    func createSelectionAnimation(delay: TimeInterval) -> CAAnimation
    func createDeselectionAnimation(delay: TimeInterval) -> CAAnimation
}
