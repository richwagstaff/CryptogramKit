import Combine
import KeyboardKit
import PuzzlestarAppUI
import SnapKit
import SwiftUI
import UIKit

open class CryptogramViewController: UIViewController, KeyboardControllerDelegate, CryptogramGameEngineDelegate {
    public var dataHandling: CryptogramDataHandling?

    public lazy var keyboardView = KeyboardView()
    public lazy var scrollView = CenteredScrollView()
    public lazy var cryptogramView = CryptogramView()

    public lazy var keyboardController = KeyboardController(
        keys: CryptogramKeyboardKeys(disabledKeys: []),
        sounds: false
    )

    public var didComplete: (() -> Void)?

    public var data: CryptogramData?

    var manager = CryptogramViewManager(rows: [])

    var isFirstLoad: Bool = true

    public var cancellables: Set<AnyCancellable> = []

    @ObservedObject public var engine = CryptogramGameEngine(items: [])

    @Published var dots = DotsViewModel(filled: 4, total: 4)
    @Published var notice = NoticeViewModel(text: "")

    private var dotsHostingController: UIHostingController<Dots>?
    private var noticeHostingController: UIHostingController<Notice>?

    override open func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager

        // manager.delegate = self

        keyboardController.configure(keyboardView)
        keyboardController.delegate = self

        observeLivesRemaining()

        loadGame()

        view.backgroundColor = .systemBackground
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if isFirstLoad {
            isFirstLoad = false
            reloadKeyboard()
            keyboardView.setNeedsLayout()
        }
    }

    open func addSubviews() {
        view.addSubview(keyboardView)
        view.addSubview(scrollView)
        scrollView.addSubview(cryptogramView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor)
        ])

        cryptogramView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cryptogramView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cryptogramView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cryptogramView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cryptogramView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cryptogramView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // TODO: Add intrinsic height to keyboard, but this is going to require a fair bit of reprogramming. Do this later, get keyboard working first
        view.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(250)
        }

        let dotsHostingController = UIHostingController(rootView: Dots(model: dots))

        addChild(dotsHostingController)
        view.addSubview(dotsHostingController.view)
        dotsHostingController.didMove(toParent: self)

        dotsHostingController.view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        self.dotsHostingController = dotsHostingController
    }

    open func loadGame() {
        self.data = dataHandling?.loadCryptogramData()

        guard let data = data else { return }

        title = data.title

        engine.items = data.items
        engine.time = data.time
        engine.livesRemaining = data.lives
        engine.maxLives = data.maxLives

        manager = CryptogramViewManager(
            items: CellViewModelGenerator().viewModels(for: engine.items),
            maxColumnsPerRow: 15
        )

        dots.filled = engine.livesRemaining
        dots.total = engine.maxLives

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager

        // This is nasty but it works for now and i can clean it all up later.
        cryptogramView.selectionManager.dataSource = manager
        cryptogramView.selectionManager.delegate = manager

        engine.delegate = self

        cryptogramView.reloadData()
        keyboardController.delegate = self

        cryptogramView.selectFirstCell()
        engine.start()
    }

    public func observeLivesRemaining() {
        engine.$livesRemaining
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.dots.filled = newValue
                self?.data?.lives = newValue
            }
            .store(in: &cancellables)
    }

    public func didInputAnswers(into items: [CryptogramItem], engine: CryptogramGameEngine) {
        let indexPaths = manager.indexPaths(whereIdIn: items.map { $0.id })

        cryptogramView.reloadCells(at: indexPaths)
        cryptogramView.selectNextCell()

        let keys = items.compactMap { $0.value }
        setKeyboardButtonsEnabled(false, forKeys: keys)
    }

    open func setKeyboardButtonEnabled(_ enabled: Bool, forKey key: String) {
        guard let indexPath = keyboardController.firstIndexPath(whereCharacter: key) else { return }
        keyboardController.setButtonEnabled(enabled, at: indexPath, keyboardView: keyboardView)
    }

    open func setKeyboardButtonsEnabled(_ enabled: Bool, forKeys keys: [String]) {
        keys.forEach { setKeyboardButtonEnabled(enabled, forKey: $0) }
    }

    open func createCompletedView(data: CryptogramData, success: Bool) -> Completed {
        Completed(
            title: success ? "Puzzle Completed!" : "Better Luck Next Time!",
            subtitle: data.title,
            phrase: data.phrase,
            author: data.author,
            buttonAction: {
                print("All done!")
            }
        )
    }

    public func gameDidFinish(engine: CryptogramGameEngine, success: Bool) {
        guard let data = data else { return }
        let completedView = createCompletedView(data: data, success: success)
        let hostingController = UIHostingController(rootView: completedView)

        print("Time: \(engine.timeElapsed())")
        if !success {
            // TODO: Remove stagger logic from engine, it should be somewhere else
            engine.revealAllRemainingItems(staggered: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.present(hostingController, animated: true, completion: nil)
                }
            }
        }
        else {
            present(hostingController, animated: true, completion: nil)
        }
    }

    public func didSelectKeyboardKey(_ key: KeyboardKey, button: KeyboardButton, controller: KeyboardController) {
        guard let keyType = key.cryptogramKeyType else { return }

        switch keyType {
        case .character:
            guard
                let item = manager.selectedItem(in: cryptogramView),
                let character = key.text
            else { return }

            engine.makeAttempt(value: character, forItemWithId: item.id)
        case .next:
            cryptogramView.selectNextCell()
        case .previous:
            cryptogramView.selectPreviousCell()
        case .blank:
            break
        }
    }

    public func wrongAnswerInputted(engine: CryptogramGameEngine) {
        if engine.livesRemaining == 1 {
            notify("Not quite - one attempt remaining!")
        }
        else {
            notify("Not quite!")
        }
    }

    public func notify(_ text: String, hidesAfter delay: TimeInterval = 5) {
        noticeHostingController?.view?.removeFromSuperview()

        let noticeHostingController = UIHostingController(rootView: Notice(model: notice))
        addChild(noticeHostingController)
        view.addSubview(noticeHostingController.view)
        noticeHostingController.didMove(toParent: self)

        noticeHostingController.view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dotsHostingController?.view.snp.bottom ?? view.safeAreaLayoutGuide).offset(20)
        }

        notice.notify(text)
        self.noticeHostingController = noticeHostingController
    }

    open func saveData() {
        data?.time = engine.timeElapsed()
        data?.lives = engine.livesRemaining

        guard let data = data else { return }
        dataHandling?.saveCryptogramData(data: data)
    }

    func reloadKeyboard() {
        keyboardController.reload(keyboardView: keyboardView)
        updateKeyboardHeightConstraint()
        view.setNeedsLayout()
    }

    func updateKeyboardHeightConstraint() {
        let keyboardHeight = keyboardController.calculateKeyboardHeight(keyboardView)
        keyboardView.snp.updateConstraints { make in
            make.height.equalTo(keyboardHeight)
        }
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            // self.outletCrosswordView.updateViewLayout(animated: true)
            self.reloadKeyboard()
        })
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = CryptogramViewController()
    vc.data = .sample()
    return vc
}
