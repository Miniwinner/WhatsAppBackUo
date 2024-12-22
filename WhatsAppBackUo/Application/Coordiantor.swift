import UIKit

final class Coordiantor {
    
    let window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
        loaderVC()
        
    }
}

private extension Coordiantor {
 
    func loaderVC() {
        let vc = LoaderVC()
        vc.delegate = self
        window?.rootViewController = vc
    }
    
    func pushToFlowBlock(_ viewController: UIViewController) {
        print("ewrqewr")
        let vc = CustomTabBarVC()
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: false)
    }
    
}

extension Coordiantor: UserInteredValid {
    func callCoo(_ viewController: UIViewController) {
        print("ewrqewr")
        let vc = CustomTabBarVC()
        vc.modalPresentationStyle = .fullScreen
        viewController.present(vc, animated: true)
    }
    
    
}

extension Coordiantor: LoaderDidLoaded {
    func pushToPass(_ viewController: UIViewController) {
        if UserDefaults.standard.value(forKey: "applocked") as! Bool {
            let vc = LockScreenVC()
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: false)
        } else {
            pushToFlowBlock(viewController)
        }
    }
    
    
    
}

extension Coordiantor: OnBoardingDelegate {
    func pushToFlow(_ viewController: UIViewController) {
        pushToFlowBlock(viewController)
    }
    
    
}
