import UIKit

open class CenteredScrollView: UIScrollView {
    private var originalContentInset: UIEdgeInsets = .zero
    private var modifyingOriginalContentInset: Bool = false

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
            contentInset.top = (bounds.size.height - contentSize.height) / 2
            modifyingOriginalContentInset = false
        }
        else {
            contentInset.top = originalContentInset.top
        }
    }
}
