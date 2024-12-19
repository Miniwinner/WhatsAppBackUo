import UIKit
import SnapKit

final class CustomTabBar: UITabBar {

    var grad: CAGradientLayer!
    
    let view = UIView() --> {
        $0.backgroundColor = .clear
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareCustomView()
        prepareTab()
        prepareGrad()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grad.frame = view.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CustomTabBar {
    
    func prepareCustomView() {
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(-10)
            make.bottom.equalToSuperview().inset(-10)
        }
    }
    
    func prepareGrad() {
        grad = CAGradientLayer()
        grad.frame = view.bounds
        grad.startPoint = CGPoint(x: 0, y: 0.5)
        grad.endPoint = CGPoint(x: 1, y: 1)
        grad.locations = [0.25,0.5,0.75,1]
        grad.colors = CGColor.backGroundColors
        grad.cornerRadius = 44
        grad.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        grad.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        grad.borderWidth = 1
        view.layer.insertSublayer(grad, at: 0)
    }
    
    func prepareTab() {
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .font: UIFont.custom(type: .glSemiBold, size: 16)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font:UIFont.custom(type: .glSemiBold, size: 16)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        
        self.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.7)
        self.tintColor = UIColor.white
        
    }
    
}
