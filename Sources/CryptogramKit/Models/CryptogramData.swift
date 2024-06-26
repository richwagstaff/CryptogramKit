import Foundation

open class CryptogramData {
    public var id: String
    public var title: String
    public var phrase: String
    public var author: String
    public var source: String?
    public var time: TimeInterval
    public var lives: Int
    public var maxLives: Int
    public var items: [CryptogramItem]

    public init(id: String, title: String, phrase: String, author: String, source: String? = nil, time: TimeInterval, lives: Int, maxLives: Int, items: [CryptogramItem]) {
        self.id = id
        self.title = title
        self.phrase = phrase
        self.author = author
        self.source = source
        self.items = items
        self.lives = lives
        self.maxLives = maxLives
        self.time = time
    }

    static func sample() -> CryptogramData {
        let phrase = "I have always depended on the kindness of strangers"
        return CryptogramData(
            id: "1",
            title: "Cryptogram #1",
            phrase: phrase,
            author: "Tennessee Williams",
            source: nil,
            time: 0,
            lives: 3,
            maxLives: 4,
            items: ItemGenerator().items(for: phrase.uppercased(), revealed: [], cipherMap: Cipher.generateNumberCipherMap())
        )
    }
}
