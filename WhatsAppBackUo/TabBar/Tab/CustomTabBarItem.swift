import Foundation
import UIKit

struct CustomTabBarItem {
    let index: Int
    let title: String
    let icon: UIImage?
    let selectedIcon: UIImage?
    let viewController: UIViewController
    
    init(index: Int, title: String, icon: UIImage?, selectedIcon: UIImage?, viewController: UIViewController) {
        self.index = index
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.viewController = viewController
        
        print("INIT - \(title)")
    }
}
