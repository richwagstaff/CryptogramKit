import Foundation
import SwiftUI
import UIKit

struct CryptogramViewRepresentable: UIViewRepresentable {
    var manager: CryptogramViewManager

    func makeUIView(context: Context) -> CryptogramView {
        let cryptogramView = CryptogramView()
        manager.configure(cryptogramView)
        return cryptogramView
    }

    func updateUIView(_ uiView: CryptogramView, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CryptogramViewDelegate {
        var parent: CryptogramViewRepresentable

        init(_ parent: CryptogramViewRepresentable) {
            self.parent = parent
        }

        func cryptogramView(_ cryptogramView: CryptogramView, didDeselectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {}

        func cryptogramView(_ cryptogramView: CryptogramView, didSelectCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) {}
    }
}

@available(iOS 15.0, *)
#Preview {
    CryptogramViewRepresentable(
        manager: CryptogramViewManager(
            phrase: "Hello, World!",
            revealed: ["H", "E", "O"],
            uppercase: true,
            cipherMap: Cipher.generateNumberCipherMap(),
            lineBreakElement: LineBreakCryptogramCellViewModel()
        )
    )
}
