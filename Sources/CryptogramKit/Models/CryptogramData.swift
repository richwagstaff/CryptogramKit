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
    public var cipherMap: [String: String]
    public var completed: Bool
    public var failed: Bool
    public var locked: Bool

    public init(id: String, title: String, phrase: String, author: String, source: String? = nil, time: TimeInterval, lives: Int, maxLives: Int, items: [CryptogramItem], cipherMap: [String: String], completed: Bool, failed: Bool, locked: Bool) {
        self.id = id
        self.title = title
        self.phrase = phrase
        self.author = author
        self.source = source
        self.items = items
        self.lives = lives
        self.maxLives = maxLives
        self.time = time
        self.cipherMap = cipherMap
        self.completed = completed
        self.failed = failed
        self.locked = locked
    }

    static func sample() -> CryptogramData {
        let phrase = "I have always depended on the kindness of strangers"
        let cipherMap = Cipher.generateNumberCipherMap()
        return CryptogramData(
            id: "1",
            title: "Cryptogram #1",
            phrase: phrase,
            author: "Tennessee Williams",
            source: nil,
            time: 0,
            lives: 3,
            maxLives: 4,
            items: ItemGenerator().items(for: phrase.uppercased(), solved: [], cipherMap: cipherMap),
            cipherMap: cipherMap,
            completed: false,
            failed: false,
            locked: false
        )
    }

    open func citation() -> String {
        var components: [String] = [author]

        if let source = source {
            components.append(source)
        }

        return components.joined(separator: " - ")
    }
}
