import Combine
import KeyboardKit
import UIKit

open class CryptogramViewController: UIViewController, KeyboardControllerDelegate, CryptogramGameEngineDelegate {
    public lazy var keyboardView = KeyboardView()
    public lazy var scrollView = CenteredScrollView()
    public lazy var cryptogramView = CryptogramView()

    public lazy var keyboardController = KeyboardController(
        keys: CryptogramKeyboardKeys(disabledKeys: []),
        sounds: false
    )

    var manager = CryptogramViewManager(rows: [])

    public var cancellables: Set<AnyCancellable> = []

    lazy var engine: CryptogramGameEngine = {
        let phrase = "I have always depended on the kindness of strangers!"

        let generator = ItemGenerator()
        let items = generator.items(for: phrase.uppercased(), revealed: [], cipherMap: Cipher.generateNumberCipherMap())

        return CryptogramGameEngine(items: items)
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager

        // manager.delegate = self

        keyboardController.configure(keyboardView)
        keyboardController.delegate = self

        loadGame()
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
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    open func loadGame() {
        manager = CryptogramViewManager(
            items: CellViewModelGenerator().viewModels(for: engine.items),
            maxColumnsPerRow: 15
        )

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager

        // This is nasty but it works for now and i can clean it all up later.
        cryptogramView.selectionManager.dataSource = manager
        cryptogramView.selectionManager.delegate = manager

        // remove cancellables
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        engine.delegate = self

        /* engine.$items
         .receive(on: RunLoop.main)
         .sink { [weak self] _ in
             self?.cryptogramView.reloadData()
         }
         .store(in: &cancellables) */

        cryptogramView.reloadData()
        keyboardController.delegate = self

        cryptogramView.selectFirstCell()
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
        }
    }

    public func correctAnswerInputted(at indexPath: CryptogramIndexPath, value: String, engine: CryptogramGameEngine) {
        // let indexPaths = manager.indexPaths(whereIdIn: <#T##[UUID]#>)
        print("correctAnswerInputted")
    }

    public func wrongAnswerInputted(at indexPath: CryptogramIndexPath, engine: CryptogramGameEngine) {
        print("wrongAnswerInputted")
    }

    public func livesDidChange(to lives: Int, enging: CryptogramGameEngine) {
        print("livesDidChange")
    }

    public func gameDidComplete(engine: CryptogramGameEngine) {
        print("gameDidComplete")
    }
}

@available(iOS 17.0, *)
#Preview {
    CryptogramViewController()
}
