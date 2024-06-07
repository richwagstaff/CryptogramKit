import UIKit

class CryptogramViewController: UIViewController {
    var manager = CryptogramViewManager(phrase: "I have always depended on the kindness of strangers!", maxColumnsPerRow: 14, cipherMap: Cipher.generateNumberCipherMap())

    var cryptogramView = CryptogramView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cryptogramView)

        cryptogramView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cryptogramView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cryptogramView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptogramView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        cryptogramView.dataSource = manager
        cryptogramView.delegate = manager
        cryptogramView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.cryptogramView.reloadData()
        }
    }
}
