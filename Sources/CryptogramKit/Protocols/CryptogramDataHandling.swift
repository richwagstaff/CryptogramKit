import Foundation

public protocol CryptogramDataHandling: AnyObject {
    func loadCryptogramData() -> CryptogramData
    func saveCryptogramData(data: CryptogramData)
    func cryptogramDidStartPlaying(data: CryptogramData)
}
