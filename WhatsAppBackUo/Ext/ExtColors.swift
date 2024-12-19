import UIKit

extension UIColor {
    convenience init(redc: CGFloat, greenc: CGFloat, bluec: CGFloat, alphac: CGFloat) {
        self.init(red: redc/255, green: greenc/255, blue: bluec/255, alpha: alphac)
    }
}




extension CGColor {
    
    static let backGroundColors: [CGColor] = [CGColor(red: 85/255, green: 71/255, blue: 107/255, alpha: 1),
                                              CGColor(red: 92/255, green: 73/255, blue: 112/255, alpha: 1),
                                              CGColor(red: 104/255, green: 77/255, blue: 130/255, alpha: 1),
                                              CGColor(red: 203/255, green: 80/255, blue: 170/255, alpha: 1)]
}
