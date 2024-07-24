import Foundation

open class Cipher {
    public static func generateNumberCipherMap() -> [String: String] {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        var cipherMap: [String: String] = [:]
        for (i, char) in alphabet.shuffled().enumerated() {
            cipherMap[String(i + 1)] = String(char)
        }

        return cipherMap
    }

    public static var cipherMap1: [String: String] {
        ["24": "X", "2": "B", "20": "L", "25": "K", "13": "P", "14": "E", "11": "Z", "3": "W", "22": "N", "8": "S", "18": "Y", "1": "H", "10": "V", "26": "G", "6": "J", "15": "I", "7": "A", "16": "M", "12": "Q", "21": "U", "17": "D", "19": "C", "9": "F", "4": "R", "23": "O", "5": "T"]
    }

    public static var cipherMap2: [String: String] {
        ["1": "E", "9": "C", "25": "S", "17": "U", "8": "N", "21": "O", "19": "B", "2": "J", "3": "V", "15": "R", "23": "Z", "5": "D", "18": "M", "12": "I", "22": "P", "16": "K", "11": "A", "6": "T", "13": "Q", "7": "F", "20": "W", "14": "H", "26": "Y", "10": "G", "4": "X", "24": "L"]
    }
}
