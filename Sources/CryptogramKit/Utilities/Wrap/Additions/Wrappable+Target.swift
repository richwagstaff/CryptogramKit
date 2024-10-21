
import Foundation

public extension Array where Element: BreakableElement {
    func wrap(maxLength: Int, removeBreakPointsAtStartAndEndOfLines: Bool = true) -> [[Element]] {
        Wrapper<Element>().wrap(
            items: self,
            maxLength: maxLength,
            removeBreakPointsAtStartAndEndOfLines: removeBreakPointsAtStartAndEndOfLines
        )
    }
}
