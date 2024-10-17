import Combine
import KeyboardKit
import PuzzlestarAppUI
import SnapKit
import SwiftUI
import UIKit

open class CryptogramViewController: UIViewController, KeyboardControllerDelegate, CryptogramGameEngineDelegate, CryptogramViewManagerDelegate, UIScrollViewDelegate {
    public var dataHandling: CryptogramDataHandling?
    public var styles = CryptogramViewControllerStyles()

    public lazy var keyboardSeparatorView = UIView()
    public lazy var keyboardView = KeyboardView()
    public lazy var scrollView = CenteredScrollView()
    public lazy var cryptogramView = CryptogramView()
    public lazy var keyboardController = KeyboardController(keys: CryptogramKeyboardKeys(disabledKeys: []), sounds: false)

    public lazy var citationLabel: UILabel = createCitationLabel()

    public var data: CryptogramData?

    public var completedView: UIView?
    public var dotsView: UIView?
    public var noticeView: UIView?

    public var manager = CryptogramViewManager(rows: [])
    public var cellViewModelGenerator = CellViewModelGenerator()

    private var isFirstLoad: Bool = true
    public var maxItemsPerRow: Int = 15

    public var cancellables: Set<AnyCancellable> = []

    @ObservedObject public var engine = CryptogramGameEngine(items: [])

    @Published public var completedViewModel = CompactCompletedViewModel(title: "", subtitle: "", message: "")
    @Published public var dots = DotsViewModel(filled: 4, total: 4)
    @Published public var notice = NoticeViewModel(text: "")

    override open func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        configureObservers()
        loadGame()
        setupNavigationItem()
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // How are we going to handle locked?????
        if data?.locked == false {
            engine.start()
            reloadKeyboard()
        }
        else {
            didAttemptToStartLockedCryptogram()
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        engine.pause()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handleFirstLoadAdjustments()
    }

    // MARK: - Setup

    func configureSubviews() {
        addSubviews()
        setupConstraints()

        configureKeyboard()

        scrollView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)
    }

    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(cryptogramView)
        view.addSubview(keyboardView)
        keyboardView.addSubview(keyboardSeparatorView)
        view.addSubview(citationLabel)
        addCompletedView()

        addDotsView()
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(keyboardView.snp.top)
        }

        dotsView?.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }

        cryptogramView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview() // .offset(-500) //  offset for testing scrolling
            make.width.equalToSuperview()
        }

        keyboardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(250)
        }

        keyboardSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(0.5)
        }

        setCompletedView(hidden: true)
        setCitation(hidden: true)
    }

    func setupNavigationItem() {
        let helpButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showInstructions))
        navigationItem.setRightBarButton(helpButton, animated: true)
    }

    func configureKeyboard() {
        keyboardController.configure(keyboardView)
        keyboardController.delegate = self

        keyboardSeparatorView.backgroundColor = .separator
    }

    open func createCitationLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = styles.citationFont
        return label
    }

    func handleFirstLoadAdjustments() {
        guard isFirstLoad else { return }
        isFirstLoad = false
        reloadKeyboard()
        keyboardView.setNeedsLayout()
    }

    func addDotsView() {
        let dotsHostingController = UIHostingController(
            rootView: Dots(model: dots)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        )

        addChild(dotsHostingController)
        view.addSubview(dotsHostingController.view)
        dotsHostingController.didMove(toParent: self)

        dotsView = dotsHostingController.view

        dotsView?.backgroundColor = .systemBackground
        dotsView?.layer.cornerRadius = 10
        dotsView?.layer.shadowColor = UIColor.black.cgColor
        dotsView?.layer.shadowRadius = 20
        dotsView?.layer.shadowOffset = .zero
        dotsView?.layer.shadowOpacity = 0.2
    }

    func configureObservers() {
        engine.$livesRemaining
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.dots.filled = newValue
                self?.data?.lives = newValue
            }
            .store(in: &cancellables)
    }

    // MARK: - Game Management

    open func loadGame() {
        self.data = dataHandling?.loadCryptogramData()

        guard let data = data else { return }

        title = data.title

        data.completed = true

        engine.items = data.items
        engine.time = data.time
        engine.livesRemaining = data.lives
        engine.maxLives = data.maxLives

        manager = CryptogramViewManager(
            items: cellViewModelGenerator.viewModels(for: engine.items),
            maxColumnsPerRow: maxItemsPerRow
        )
        manager.configure(cryptogramView)
        manager.delegate = self

        dots.filled = engine.livesRemaining
        dots.total = engine.maxLives

        engine.delegate = self

        cryptogramView.reloadData()

        cryptogramView.selectFirstCell(animated: true)

        if engine.state == .completed || engine.state == .failed {
            showCompleted(true, animated: false)
        }

        reloadKeyboard()
    }

    open func saveData() {
        data?.time = engine.timeElapsed()
        data?.lives = engine.livesRemaining
        data?.completed = engine.isCompleted()
        data?.failed = engine.state == .failed

        guard let data = data else { return }
        dataHandling?.saveCryptogramData(data: data)
    }

    public func showCompleted(_ completed: Bool, animated: Bool) {
        guard let data = data else { return }

        let success = engine.state == .completed
        completedViewModel.title = success ? "Congratulations!" : "Better Luck Next Time!"
        completedViewModel.message = success ? "⏱️ \(data.time.formattedTime())" : nil
        completedViewModel.styles = styles.completedStyles

        setCompletedView(hidden: !completed)
        setCitation(hidden: !completed)

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    public func addCompletedView() {
        let completedView = CompactCompleted(viewModel: completedViewModel, shareAction: { [weak self] in
            self?.shareResult()
        })

        let hostingController = UIHostingController(rootView: completedView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .secondarySystemBackground
        hostingController.didMove(toParent: self)

        self.completedView = hostingController.view
        self.completedView?.layer.shadowColor = UIColor.black.cgColor
        self.completedView?.layer.shadowOpacity = 0.2
        self.completedView?.layer.shadowRadius = 20
    }

    public func setCompletedView(hidden: Bool) {
        if completedView == nil {
            addCompletedView()
        }

        completedView?.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(keyboardView)
            make.height.equalTo(keyboardView)

            if hidden {
                make.top.equalTo(view.snp.bottom)
            }
            else {
                make.top.equalTo(keyboardView.snp.top)
            }
        }
    }

    public func setCitation(hidden: Bool) {
        citationLabel.text = data?.citation()
        citationLabel.font = styles.citationFont

        citationLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)

            if hidden {
                make.top.equalTo(view.snp.bottom)
            }
            else {
                make.bottom.equalTo(completedView?.snp.top ?? keyboardView.snp.top).offset(-8)
            }
        }
    }

    // MARK: - Actions

    @objc func showInstructions() {
        let instructions = CryptogramInstructions()
            .closeBar(alignment: .leading) { [weak self] in
                self?.dismiss(animated: true)
            }

        let hostingController = UIHostingController(rootView: instructions)
        present(hostingController, animated: true)
    }

    open func didAttemptToStartLockedCryptogram() {}

    // MARK: - Keyboard Management

    func setKeyboardEnabled(_ enabled: Bool) {
        keyboardView.isUserInteractionEnabled = enabled
    }

    func reloadKeyboard() {
        setKeyboardEnabled(engine.isPlaying)

        keyboardController.reload(keyboardView: keyboardView)
        updateKeyboardHeightConstraint()
        view.setNeedsLayout()

        updateKeyboardButtons()
    }

    func updateKeyboardButtons() {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        setKeyboardButtonsEnabled(true, forKeys: alphabet.map { String($0) })
        configureKeyboardKeys(alphabet.map { String($0) }) { key in
            key.styles.textColor = .label
            key.styles.hoverViewTextColor = .label
            key.styles.font = UIFont.systemFont(ofSize: key.styles.font.pointSize)
        }

        let solvedKeys = charactersForState(.fullySolved)
        setKeyboardButtonsEnabled(false, forKeys: solvedKeys)

        let partiallySolvedKeys = charactersForState(.partiallySolved)
        configureKeyboardKeys(partiallySolvedKeys) { key in
            key.styles.textColor = .systemGreen
            key.styles.hoverViewTextColor = .systemGreen
            key.styles.font = UIFont.boldSystemFont(ofSize: key.styles.font.pointSize)
        }
    }

    func updateKeyboardHeightConstraint() {
        let keyboardHeight = keyboardController.calculateKeyboardHeight(keyboardView)
        keyboardView.snp.updateConstraints { make in
            make.height.equalTo(keyboardHeight)
        }
    }

    open func configureKeyboardKey(_ key: String, configure: @escaping (inout KeyboardKey) -> Void) {
        guard let indexPath = keyboardController.firstIndexPath(whereCharacter: key) else { return }
        keyboardController.configureKey(at: indexPath, keyboardView: keyboardView, configure: configure)
    }

    open func setKeyboardButtonEnabled(_ enabled: Bool, forKey key: String) {
        guard let indexPath = keyboardController.firstIndexPath(whereCharacter: key) else { return }
        keyboardController.setButtonEnabled(enabled, at: indexPath, keyboardView: keyboardView)
    }

    open func configureKeyboardKeys(_ keys: [String], configure: @escaping (inout KeyboardKey) -> Void) {
        keys.forEach { configureKeyboardKey($0, configure: configure) }
    }

    open func setKeyboardButtonsEnabled(_ enabled: Bool, forKeys keys: [String]) {
        keys.forEach { setKeyboardButtonEnabled(enabled, forKey: $0) }
    }

    // MARK: - KeyboardControllerDelegate

    open func didSelectKeyboardKey(_ key: KeyboardKey, button: KeyboardButton, controller: KeyboardController) {
        guard let keyType = key.cryptogramKeyType else { return }

        switch keyType {
        case .character:
            guard
                let item = manager.selectedItem(in: cryptogramView),
                let character = key.text
            else { return }

            engine.makeAttempt(value: character, forItemWithId: item.id)
        case .next:
            cryptogramView.selectNextCell(animated: true)
        case .previous:
            cryptogramView.selectPreviousCell(animated: true)
        case .blank:
            break
        }
    }

    // MARK: - CryptogramGameEngineDelegate

    open func gameDidBegin(engine: CryptogramGameEngine) {
        guard let data = data else { return }
        dataHandling?.cryptogramDidStartPlaying(data: data)
    }

    open func gameDidFinish(engine: CryptogramGameEngine) {
        saveData()

        if engine.state.hasFailed {
            selectFirstIncorrectCell()
            engine.revealAllRemainingItems(staggered: true) {
                self.showCompleted(true, animated: true)
            }
        }
        else {
            showCompleted(true, animated: true)
        }
    }

    public func selectFirstIncorrectCell() {
        guard
            let id = engine.items.first(where: { !$0.isCorrect })?.id,
            let indexPath = manager.firstIndexPath(whereId: id)
        else { return }

        cryptogramView.selectCell(at: indexPath, animated: true)
    }

    public func didInputAnswers(into items: [CryptogramItem], engine: CryptogramGameEngine) {
        let indexPaths = manager.indexPaths(whereIdIn: items.map { $0.id })

        cryptogramView.reloadCells(at: indexPaths)
        cryptogramView.selectNextCell(animated: true)
    }

    public func wrongAnswerInputted(engine: CryptogramGameEngine) {
        if engine.livesRemaining == 1 {
            notify("Not quite - one attempt remaining!")
        }
        else {
            notify("Not quite!")
        }
    }

    public func didSolveCode(_ code: String, engine: CryptogramGameEngine) {
        let items = engine.items.filter { $0.code == code }
        let itemIds = items.map { $0.id }
        let indexPaths = manager.indexPaths(whereIdIn: itemIds)

        cryptogramView.reloadCells(at: indexPaths)

        let cells = cryptogramView.cells(at: indexPaths)
        cryptogramView.animations.animateCodeSolved(cells)

        reloadKeyboard()
    }

    public func notify(_ text: String, hidesAfter delay: TimeInterval = 5) {
        noticeView?.removeFromSuperview()

        let noticeHostingController = UIHostingController(rootView: Notice(model: notice))
        addChild(noticeHostingController)
        view.addSubview(noticeHostingController.view)
        noticeHostingController.didMove(toParent: self)

        noticeHostingController.view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dotsView?.snp.bottom ?? view.safeAreaLayoutGuide).offset(20)
        }

        noticeHostingController.view.backgroundColor = .clear
        notice.notify(text, hideAfter: delay)
        noticeView = noticeHostingController.view
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            // self.outletCrosswordView.updateViewLayout(animated: true)
            self.reloadKeyboard()
        })
    }

    open func shareResult() {
        guard let data = data else { return }

        let message = "I just completed the cryptogram '\(data.title)' in \(data.time.formattedTime())! Can you beat my time?"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)

        present(activityViewController, animated: true)
    }

    open func selectedItem() -> CryptogramItem? {
        guard let selectedViewItem = manager.selectedItem(in: cryptogramView) else { return nil }
        return engine.items.first(where: { $0.id == selectedViewItem.id })
    }

    open func charactersForState(_ state: CryptogramCodeSolutionState) -> [String] {
        engine.items.characters(state: state, cipherMap: data?.cipherMap ?? [:])
    }

    // MARK: - Cryptogram View Manager Delegate

    open func cryptogramViewManager(_ manager: CryptogramViewManager, didModifyItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {}

    open func cryptogramViewManager(_ manager: CryptogramViewManager, didSelectItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        updateKeyboardButtons()
    }

    open func cryptogramViewManager(_ manager: CryptogramViewManager, didInputWrongAnswerAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {}

    // MARK: - Scroll View Delegate

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let highlightDots = scrollView.contentOffset.y > 0.5 - view.safeAreaInsets.top - scrollView.contentInset.top
        emphasizeDotsView(highlightDots)
    }

    // MARK: - Shadow

    open func emphasizeDotsView(_ emphasize: Bool) {
        dotsView?.layer.shadowOpacity = emphasize ? 0.15 : 0
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = CryptogramViewController()
    vc.data = .sample()
    return vc
}
