import UIKit

open class CenteredScrollView: UIScrollView {
    private var originalContentInset: UIEdgeInsets = .zero
    private var modifyingOriginalContentInset: Bool = false

    public var edgesForExtendedLayout: UIRectEdge = .all

    override open var contentInset: UIEdgeInsets {
        didSet {
            if !modifyingOriginalContentInset {
                originalContentInset = contentInset
            }
        }
    }

    override open var contentSize: CGSize {
        didSet {
            updateTopContentInsetIfNeeded()
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateTopContentInsetIfNeeded()
    }

    private func updateTopContentInsetIfNeeded() {
        if contentSize.height < bounds.size.height {
            modifyingOriginalContentInset = true

            var extendedLayoutOffset: CGFloat = 0
            if edgesForExtendedLayout.contains(.top) {
                extendedLayoutOffset += safeAreaInsets.top
            }

            if edgesForExtendedLayout.contains(.bottom) {
                extendedLayoutOffset -= safeAreaInsets.bottom
            }

            contentInset.top = (bounds.size.height - extendedLayoutOffset - contentSize.height) / 2
            modifyingOriginalContentInset = false
        }
        else {
            contentInset.top = originalContentInset.top
        }
    }
}
