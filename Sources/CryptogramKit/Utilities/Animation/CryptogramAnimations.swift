import UIKit

open class CryptogramAnimations {
    var animationProvider: CryptogramAnimationProvider

    public enum Animation: String {
        case selection
        case deselection
        case codeSolved
    }

    init(animationProvider: CryptogramAnimationProvider = DefaultCryptogramAnimationProvider()) {
        self.animationProvider = animationProvider
    }

    public func animateCellSelection(
        _ view: UIView,
        after delay: TimeInterval = 0,
        bringViewToFront: Bool = true
    ) {
        let animation = animationProvider.createSelectionAnimation()
        animation.beginTime = CACurrentMediaTime() + delay
        addAnimation(animation, to: view, forKey: Animation.selection.rawValue, bringViewToFront: bringViewToFront)
    }

    public func animateCellDeselection(
        _ view: UIView,
        after delay: TimeInterval = 0,
        bringViewToFront: Bool = true
    ) {
        let animation = animationProvider.createDeselectionAnimation()
        animation.beginTime = CACurrentMediaTime() + delay
        addAnimation(animation, to: view, forKey: Animation.deselection.rawValue, bringViewToFront: bringViewToFront)
    }

    public func animateCodeSolved(
        _ view: UIView,
        after delay: TimeInterval = 0,
        bringViewToFront: Bool = true
    ) {
        let animation = animationProvider.createCodeSolvedAnimation()
        animation.beginTime = CACurrentMediaTime() + delay
        addAnimation(animation, to: view, forKey: Animation.codeSolved.rawValue, bringViewToFront: bringViewToFront)
    }

    public func animateCodeSolved(
        _ views: [UIView],
        after delay: TimeInterval = 0,
        staggered: Bool = false,
        bringViewsToFront: Bool = true
    ) {
        for (i, view) in views.enumerated() {
            let offset = staggered ? TimeInterval(i) * delay : 0
            animateCodeSolved(view, after: offset, bringViewToFront: bringViewsToFront)
        }
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
