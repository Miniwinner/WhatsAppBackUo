import UIKit

final class WhatsTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabBarForUse()
        setCustomTab()
        selectedIndex = 1
        selectedIndex = 0
    }
    
   
}

private extension WhatsTabBar {
    
    func setCustomTab() {
        let tab = CustomTabBar()
        setValue(tab, forKey: "tabBar")
    }
    
    func prepareTabBarForUse() {
        
        viewControllers = [returnVC(type: .chats),returnVC(type: .gallery),returnVC(type: .documents),returnVC(type: .settings)]
    }
    
    func returnVC(type: TabBarTitles) -> UIViewController {
        let vc: UIViewController?
        switch type {
        case .chats:
            vc = UINavigationController(rootViewController: ChatsVC())
            vc?.tabBarItem = UITabBarItem(title: type.text,
                                          image: UIImage(named: type.tabBarPhoto),
                                          selectedImage: UIImage(named: type.tabBarPhoto))
        case .gallery:
            vc = UINavigationController(rootViewController: GalleryVC())
            vc?.tabBarItem = UITabBarItem(title: type.text,
                                          image: UIImage(named: type.tabBarPhoto),
                                          selectedImage: UIImage(named: type.tabBarPhoto))
        case .documents:
            vc = UINavigationController(rootViewController: DocumentsVC())
            vc?.tabBarItem = UITabBarItem(title: type.text,
                                          image: UIImage(named: type.tabBarPhoto),
                                          selectedImage: UIImage(named: type.tabBarPhoto))
        case .settings:
            vc = UINavigationController(rootViewController: SettingsVC())
            vc?.tabBarItem = UITabBarItem(title: type.text,
                                          image: UIImage(named: type.tabBarPhoto),
                                          selectedImage: UIImage(named: type.tabBarPhoto))
        }
        return vc ?? UIViewController()
    }
    
}


