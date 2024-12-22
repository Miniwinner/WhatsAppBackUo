import Foundation
import UIKit

class CustomTabBar: UIStackView {
    
    private let tabBarTabs: [CustomTabBarItem]
    
    private var customTabItemViews: [CustomTabItemView] = []
    
    var onTabSelected: ((Int) -> Void)
    
    
    init(tabBarTabs: [CustomTabBarItem], onTabSelected: @escaping ((Int) -> Void)) {
        self.tabBarTabs = tabBarTabs
        self.onTabSelected = onTabSelected
        super.init(frame: .zero)
        
        setupTabBartabs()
        setupHierarchy()
        setupProperties()
        self.setNeedsLayout()
        selectItem(index: 0)
        print("tab bar inited")
    }

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBartabs() {
        self.tabBarTabs.forEach { tabBarItem in
            customTabItemViews.append(CustomTabItemView(with: tabBarItem, callback: { index in
                self.selectItem(index: index)
            }))
        }
    }
    
    private func setupHierarchy() {
        addArrangedSubviews(customTabItemViews)
    }
    

    
    private func setupProperties() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.alignment = .fill
        self.spacing = UIDevice.pad ? 10:20
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 0, left: UIDevice.pad ? 80:32, bottom: 0, right: UIDevice.pad ? 80:32)
        
//        self.backgroundColor = .clear
        
        makeWhite()
        setupCornerRadius(UIDevice.pad ? 70:44)
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        customTabItemViews.forEach { tab in
//            tab.translatesAutoresizingMaskIntoConstraints = false
            tab.anchor(top: self.topAnchor, bottom: self.bottomAnchor)
//            tab.widthAnchor.constraint(equalToConstant: 80).isActive = true
            tab.clipsToBounds = true
        }
    }
    
    private func selectItem(index: Int) {
        customTabItemViews.forEach { item in
            item.isSelected = item.index == index
        }
        onTabSelected(index)
    }
}
