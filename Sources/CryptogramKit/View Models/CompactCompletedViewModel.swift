import SwiftUI

public class CompactCompletedViewModel: ObservableObject {
    @Published public var title: String
    @Published public var subtitle: String?
    @Published public var message: String?
    @Published public var styles = CompactCompletedStyles()

    public init(
        title: String,
        subtitle: String?,
        message: String?,
        styles: CompactCompletedStyles = .init()
    ) {
        self.title = title
        self.subtitle = subtitle
        self.message = message
        self.styles = styles
    }
}
