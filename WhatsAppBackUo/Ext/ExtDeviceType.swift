import UIKit

extension UIDevice {
    static let pad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    static let phone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}
