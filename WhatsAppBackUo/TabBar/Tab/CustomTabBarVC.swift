import Foundation
import UIKit

class CustomTabBarVC: UITabBarController {
    lazy var chat = ChatsVC()
    lazy var vcchat = UINavigationController(rootViewController: chat)
    
    lazy var gall = GalleryVC()
    lazy var vcgall = UINavigationController(rootViewController: gall)
    
    lazy var docs = DocumentsVC()
    lazy var vcdock = UINavigationController(rootViewController: docs)
    
    lazy var sett = SettingsVC()
    lazy var vcsett = UINavigationController(rootViewController: sett)
    
    private lazy var chatsTab = CustomTabBarItem(
        index: 0,
        title: "Chats",
        icon: UIImage(named: "chats")?.withTintColor(.white.withAlphaComponent(0.6), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(named: "chats")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: vcchat)
    
    private lazy var galleryTab = CustomTabBarItem(
        index: 1,
        title: "Gallery",
        icon: UIImage(named: "gallery")?.withTintColor(.white.withAlphaComponent(0.6), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(named: "gallery")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: vcgall)
    
    private lazy var documentsTab = CustomTabBarItem(
        index: 2,
        title: "Documents",
        icon: UIImage(named: "documents")?.withTintColor(.white.withAlphaComponent(0.6), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(named: "documents")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: vcdock)
    
    private lazy var settingsTab = CustomTabBarItem(
        index: 3,
        title: "Settings",
        icon: UIImage(named: "settings")?.withTintColor(.white.withAlphaComponent(0.6), renderingMode: .alwaysOriginal),
        selectedIcon: UIImage(named: "settings")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        viewController: vcsett)
    
    private lazy var tabBarTabs: [CustomTabBarItem] = [chatsTab, galleryTab, documentsTab, settingsTab]
    
    private var customTabBar: CustomTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        
        setupHierarchy()
        setupLayoutConstraints()
        setupProperties()
        view.setNeedsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCustomTabBar() {
        self.customTabBar = CustomTabBar(tabBarTabs: tabBarTabs, onTabSelected: { [weak self] index in
            self?.selectTabWith(index: index)
            print("did tab bar inited")
           
        })
        print("init?")
        chat.linkToView = self.customTabBar
        gall.linkToView = self.customTabBar
        docs.linkToView = self.customTabBar
        sett.linkToView = self.customTabBar
    }
    
    
    
    private func setupHierarchy() {
        view.addSubview(customTabBar)
    }
    
    private func setupLayoutConstraints() {
        customTabBar.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor,
                            paddingLeft: UIDevice.pad ? 120:0,
                            paddingRight: UIDevice.pad ? 120:0,
                            height: UIDevice.pad ? 180:108)
    }
    
    private func setupProperties() {
        tabBar.isHidden = true
        customTabBar.addShadow()
        
        self.selectedIndex = 0
        let controllers = tabBarTabs.map { item in
            return item.viewController
        }
        self.setViewControllers(controllers, animated: true)
    }
    
    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }
}
