import Foundation

open class Cipher {
    static func generateNumberCipherMap() -> [String: String] {
        var cipherMap: [String: String] = [:]
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let shuffled = alphabet.shuffled()

        for (i, char) in shuffled.enumerated() {
            cipherMap[String(char)] = String(i + 1)
        }

        return cipherMap
    }
}
