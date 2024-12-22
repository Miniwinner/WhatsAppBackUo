import UIKit
import SnapKit

enum TopElementType {
    case title3btn
    case title2btn
    case backTitleLogo
    case back
    case title
    case backTitle
}

final class TopElement: UIView {

    lazy var titleLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ?40:24)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.3
    }
  
    var title: String? {
        didSet {
            self.titleLbl.text = title
        }
    }
    
    lazy var plusBtn = BtnMine() --> {$0.imageViewMine.image = (UIImage(named: "plus"))}
    lazy var qrcodeBtn = BtnMine() --> {$0.imageViewMine.image = (UIImage(named: "qrcode"))}
    lazy var askBtn = BtnMine() --> {$0.imageViewMine.image = (UIImage(named: "ask"))}
    lazy var backBtn = BtnMine() --> {$0.imageViewMine.image = (UIImage(named: "backAction"))}
    private lazy var logo = UIImageView() --> {$0.image = UIImage(named: "logo")}
    
    private lazy var stack = UIStackView() --> {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 10
    }
    
    init(type: TopElementType) {
        super.init(frame: .zero)
        prepareView()
        prepareSubs(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TopElement {
    
    func prepareView() {
        makeWhite()
        layer.cornerRadius = UIDevice.pad ? 44 : 26
    }
    
    func prepareSubs(type: TopElementType) {
        switch type {
        case.title3btn:
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?54:24)
            }
            stack.addArrangedSubview(plusBtn)
            stack.addArrangedSubview(qrcodeBtn)
            stack.addArrangedSubview(askBtn)
            
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(UIDevice.pad ? 30:15)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?60:30)
                make.right.lessThanOrEqualTo(stack)
            }
            
            for views in stack.arrangedSubviews {
               
                views.snp.makeConstraints { make in
                    make.size.equalTo(UIDevice.pad ?44:24)
                    
                }
            }
            
        case .title2btn:
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?54:24)
            }
            stack.addArrangedSubview(plusBtn)
            stack.addArrangedSubview(qrcodeBtn)
            
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(UIDevice.pad ? 30:15)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?60:30)
                make.right.lessThanOrEqualTo(stack)
            }
            addSubview(stack)
        case .backTitleLogo:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(UIDevice.pad ? 25:10)
                make.centerY.equalToSuperview()
                make.size.equalTo(UIDevice.pad ?54:24)
            }
            addSubview(logo)
            logo.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(UIDevice.pad ? 20:10)
                make.size.equalTo(UIDevice.pad ?68:38)
            }
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(UIDevice.pad ?60:30)
                make.centerY.equalToSuperview()
                make.left.equalTo(backBtn.snp.right).inset(-10)
                make.right.equalTo(logo.snp.left).inset(-10)
            }
        case .back:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(UIDevice.pad ? 25:10)
                make.centerY.equalToSuperview()
                make.size.equalTo(UIDevice.pad ?54:24)
            }
        case .title:
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(UIDevice.pad ?60:30)
                make.center.equalToSuperview()
                make.left.equalToSuperview().inset(UIDevice.pad ? 25:15)
                make.right.equalToSuperview().inset(15)
            }
        case .backTitle:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(UIDevice.pad ? 25:10)
                make.centerY.equalToSuperview()
                make.size.equalTo(UIDevice.pad ?54:24)
            }
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(UIDevice.pad ?60:30)
                make.center.equalToSuperview()
                make.left.lessThanOrEqualTo(backBtn)
                make.right.equalToSuperview().inset(10)
            }
        }
//        self.layoutIfNeeded()
    }
    
}
