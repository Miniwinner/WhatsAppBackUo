import UIKit

extension UIView {
    func makeWhite() {
        layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        layer.borderWidth = 1
        backgroundColor = .white.withAlphaComponent(0.3)
    }
}
