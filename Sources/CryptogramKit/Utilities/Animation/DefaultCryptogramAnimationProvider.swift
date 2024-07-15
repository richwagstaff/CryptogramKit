import Foundation
import QuartzCore

open class DefaultCryptogramAnimationProvider: CryptogramAnimationProvider {
    public func createSelectionAnimation(delay: TimeInterval) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.1
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.beginTime = CACurrentMediaTime() + delay
        animation.autoreverses = true
        return animation
    }

    func createDeselectionAnimation(delay: TimeInterval) -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 0.9
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.beginTime = CACurrentMediaTime() + delay
        animation.autoreverses = true
        return animation
    }
}
