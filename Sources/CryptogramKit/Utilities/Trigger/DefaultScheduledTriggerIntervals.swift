import Foundation

open class DefaultScheduledTriggerIntervals: ScheduledTriggerIntervalProtocol {
    public var count: Int

    public init(count: Int) {
        self.count = count
    }

    public func triggerIntervals() -> [TimeInterval] {
        let delay: TimeInterval = 0.5

        return (0 ..< count).map { TimeInterval($0) * delay }
    }
}
