import Foundation

public protocol CryptogramDataHandling {
    func loadCryptogramData() -> CryptogramData
    func saveCryptogramData(data: CryptogramData)
    func cryptogramDidStartPlaying(data: CryptogramData)
}
