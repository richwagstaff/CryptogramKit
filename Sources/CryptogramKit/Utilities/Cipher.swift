import Foundation

open class Cipher {
    public static func generateNumberCipherMap() -> [String: String] {
        var cipherMap: [String: String] = [:]
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let shuffled = alphabet.shuffled()

        for (i, char) in shuffled.enumerated() {
            cipherMap[String(char)] = String(i + 1)
        }

        print(cipherMap)

        return cipherMap
    }

    public static var cipherMap1: [String: String] {
        ["X": "24", "B": "2", "L": "20", "K": "25", "P": "13", "E": "14", "Z": "11", "W": "3", "N": "22", "S": "8", "Y": "18", "H": "1", "V": "10", "G": "26", "J": "6", "I": "15", "A": "7", "M": "16", "Q": "12", "U": "21", "D": "17", "C": "19", "F": "9", "R": "4", "O": "23", "T": "5"]
    }

    public static var cipherMap2: [String: String] {
        ["E": "1", "C": "9", "S": "25", "U": "17", "N": "8", "O": "21", "B": "19", "J": "2", "V": "3", "R": "15", "Z": "23", "D": "5", "M": "18", "I": "12", "P": "22", "K": "16", "A": "11", "T": "6", "Q": "13", "F": "7", "W": "20", "H": "14", "Y": "26", "G": "10", "X": "4", "L": "24"]
    }
}
