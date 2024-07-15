import Foundation
import UIKit

public struct CryptogramViewControllerStyles {
    public var completedStyles = CompactCompletedStyles()
    public var citationFont: UIFont = .preferredFont(forTextStyle: .body)

    public init(
        completedStyles: CompactCompletedStyles = CompactCompletedStyles(),
        citationFont: UIFont = .preferredFont(forTextStyle: .body)
    ) {
        self.completedStyles = completedStyles
        self.citationFont = citationFont
    }
}
