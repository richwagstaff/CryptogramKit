import KeyboardKit
import UIKit

open class CryptogramViewController: UIViewController, KeyboardControllerDelegate, CryptogramViewManagerDelegate {
    lazy var keyboardView = KeyboardView()

    public lazy var keyboardController = KeyboardController(
        keys: CryptogramKeyboardKeys(disabledKeys: ["A", "Y", "O", "D"]),
        sounds: false
    )

    var manager = CryptogramViewManager(
        phrase: "I have always depended on the kindness of strangers!",
        revealed: ["A", "Y", "O", "D"],
        maxColumnsPerRow: 14,
        cipherMap: Cipher.generateNumberCipherMap()
    )

    var cryptogramView = CryptogramView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(keyboardView)

        let scrollView = CenteredScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: keyboardView.topAnchor)
        ])

        scrollView.addSubview(cryptogramView)
        cryptogramView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cryptogramView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            cryptogramView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cryptogramView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cryptogramView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cryptogramView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        manager.delegate = self

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager
        cryptogramView.reloadData()
        manager.selectFirstCell(in: cryptogramView)

        // TODO: Add intrinsic height to keyboard, but this is going to require a fair bit of reprogramming. Do this later, get keyboard working first
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 250)
        ])

        keyboardController.configure(keyboardView)
        keyboardController.delegate = self
    }

    public func didSelectKeyboardKey(_ key: KeyboardKey, button: KeyboardButton, controller: KeyboardController) {
        guard let keyType = key.cryptogramKeyType else { return }

        switch keyType {
        case .character:
            manager.inputCharacter(key.text!, into: cryptogramView)
        case .next:
            manager.selectNextCell(in: cryptogramView)
        case .previous:
            manager.selectPreviousCell(in: cryptogramView)
        }
    }

    public func cryptogramViewManager(_ manager: CryptogramViewManager, didModifyItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        guard
            let value = manager.item(at: indexPath)?.value,
            let indexPath = keyboardView.firstIndexPathOfButton(withText: value)
        else {
            return
        }

        keyboardController.setButtonEnabled(false, at: indexPath, keyboardView: keyboardView)
    }

    public func cryptogramViewManager(_ manager: CryptogramViewManager, didSelectItemAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        print("Did select item at \(indexPath)")
    }

    public func cryptogramViewManager(_ manager: CryptogramViewManager, didInputWrongAnswerAt indexPath: CryptogramIndexPath, in cryptogramView: CryptogramView) {
        print("Did input wrong answer at \(indexPath)")
    }

    public func cryptogramViewManager(_ manager: CryptogramViewManager, didComplete cryptogramView: CryptogramView) {
        print("did complete")
    }
}


@available(iOS 17.0, *)
#Preview {
    CryptogramViewController()
}
