import UIKit

enum CustomFont {
    case glBlack
    case glBold
    case glExtraBold
    case glRegular
    case glSemiBold
    case glThin
    
    var name: String {
        switch self {
        case .glBlack:
            return "Gilroy-Black"
        case .glBold:
            return "Gilroy-Bold"
        case .glExtraBold:
            return "Gilroy-Extrabold"
        case .glRegular:
            return "Gilroy-Regular"
        case .glSemiBold:
            return "Gilroy-Semibold"
        case .glThin:
            return "Gilroy-Thin"
        }
    }
}

extension UIFont {
    static func custom(type: CustomFont, size: CGFloat) -> UIFont{
        return UIFont(name: type.name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
