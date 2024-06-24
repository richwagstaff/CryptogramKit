import Foundation

public protocol CryptogramViewDataSource: AnyObject {
    func numberOfRows(in cryptogramView: CryptogramView) -> Int
    func rowSpacing(in cryptogramView: CryptogramView) -> CGFloat
    func cryptogramView(_ cryptogramView: CryptogramView, numberOfItemsInRow row: Int) -> Int
    func cryptogramView(_ cryptogramView: CryptogramView, heightForRow row: Int) -> CGFloat
    func cryptogramView(_ cryptogramView: CryptogramView, widthForCell cell: CryptogramViewCell, at indexPath: CryptogramIndexPath) -> CGFloat
    func cryptogramView(_ cryptogramView: CryptogramView, cellForRowAt indexPath: CryptogramIndexPath, reusableCell: CryptogramViewCell?) -> CryptogramViewCell
}
