import SwiftUI

public struct CompactCompletedStyles {
    public var titleFont: Font = .title
    public var subtitleFont: Font = .headline
    public var messageFont: Font = .body
    public var shareFont: Font = .body

    public init(
        titleFont: Font = .title,
        subtitleFont: Font = .headline,
        messageFont: Font = .body,
        shareFont: Font = .body
    ) {
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.messageFont = messageFont
        self.shareFont = shareFont
    }
}
