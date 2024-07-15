import UIKit

open class CryptogramAnimations {
    var animationProvider: CryptogramAnimationProvider

    public enum Animation: String {
        case selection
        case deselection
    }

    init(
        animationProvider: CryptogramAnimationProvider = DefaultCryptogramAnimationProvider()
    ) {
        self.animationProvider = animationProvider
    }

    public func animateCellSelection(
        _ view: UIView,
        after delay: TimeInterval = 0,
        bringViewToFront: Bool = true
    ) {
        let animation = animationProvider.createSelectionAnimation(delay: delay)
        addAnimation(animation, to: view, forKey: Animation.selection.rawValue, bringViewToFront: bringViewToFront)
    }

    public func animateCellDeselection(
        _ view: UIView,
        after delay: TimeInterval = 0,
        bringViewToFront: Bool = true
    ) {
        let animation = animationProvider.createDeselectionAnimation(delay: delay)
        addAnimation(animation, to: view, forKey: Animation.deselection.rawValue, bringViewToFront: bringViewToFront)
    }

    public func addAnimation(
        _ animation: CAAnimation,
        to view: UIView,
        forKey key: String,
        bringViewToFront: Bool
    ) {
        view.layer.add(animation, forKey: key)

        if bringViewToFront {
            view.superview?.bringSubviewToFront(view)
        }
    }
}
