import Foundation
import UIKit

open class ScheduledTrigger {
    private var displayLink: CADisplayLink?
    private var startedAt: TimeInterval = 0
    private(set) var isRunning: Bool = false

    public var triggerIntervals: [TimeInterval] = []

    public var triggerHandler: (Int) -> Void = { _ in }
    public var completionHandler: () -> Void = {}

    private var index: Int = 0
    private var nextTriggerInterval: TimeInterval?

    public init(
        intervals: [TimeInterval]
    ) {
        self.triggerIntervals = intervals
    }

    public init(
        intervals intervalProtocol: ScheduledTriggerIntervalProtocol
    ) {
        self.triggerIntervals = intervalProtocol.triggerIntervals()
    }

    public func start(trigger: @escaping (Int) -> Void, completion: @escaping () -> Void = {}) {
        guard !isRunning else { return }

        triggerHandler = trigger
        completionHandler = completion
        index = 0
        isRunning = true
        startDisplayLink()
        startedAt = CACurrentMediaTime()
        nextTriggerInterval = triggerIntervals.first
    }

    public func stop() {
        isRunning = false
        stopDisplayLink()
    }

    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func update() {
        let elapsed = CACurrentMediaTime() - startedAt

        if let interval = nextTriggerInterval {
            if elapsed >= interval {
                triggerHandler(index)
                index += 1

                if index < triggerIntervals.count {
                    nextTriggerInterval = triggerIntervals[index]
                }
                else {
                    stop()
                    completionHandler()
                }
            }
        }
        else {
            stop()
            completionHandler()
        }
    }
}
