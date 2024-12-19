import UIKit

class SettingsRouter {
    
    weak var controller: UIViewController?
    
    func showPass() {
        let from = controller
        let destiantion = LockScreenVC(flow: true)
        destiantion.hidesBottomBarWhenPushed = true
        showChatMedia(from!, destiantion)
    }
    
    func showGuide() {
        let from = controller
        let destiantion = GuideScreen()
        destiantion.hidesBottomBarWhenPushed = true
        showChatMedia(from!, destiantion)
    }
    
}


private extension SettingsRouter {
    
    func showChatMedia(_ from: UIViewController, _ to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
    
}
