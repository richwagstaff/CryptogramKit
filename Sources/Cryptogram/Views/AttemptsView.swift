import UIKit

class AttemptsView: UIView {
    var attemptsRemaining: Int = 0
    var totalAttempts: Int = 0

    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    init(attemptsRemaining: Int, totalAttempts: Int) {
        self.attemptsRemaining = attemptsRemaining
        self.totalAttempts = totalAttempts
        super.init(frame: .zero)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }

    private func addSubviews() {
        addSubview(stackView)
    }

    private func reloadViews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for _ in 0..<attemptsRemaining {
            let view = UIView()
            view.backgroundColor = .green
            stackView.addArrangedSubview(view)
        }

        for _ in 0..<(totalAttempts - attemptsRemaining) {
            let view = UIView()
            view.backgroundColor = .red
            stackView.addArrangedSubview(view)
        }
    }
}
