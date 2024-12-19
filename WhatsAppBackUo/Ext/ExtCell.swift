import UIKit

extension UITableViewCell {
    
    static var identifier: String { return String(describing: Self.self) }
    
}

extension UICollectionViewCell {
    static var identifier: String { return String(describing: Self.self) }
}
