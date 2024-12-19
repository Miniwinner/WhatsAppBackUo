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
        $0.font = .custom(type: .glSemiBold, size: 24)
        $0.textAlignment = .center
    }
  
    var title: String? {
        didSet {
            self.titleLbl.text = title
        }
    }
    
    lazy var plusBtn = UIButton() --> {$0.setImage(UIImage(named: "plus"), for: .normal)}
    lazy var qrcodeBtn = UIButton() --> {$0.setImage(UIImage(named: "qrcode"), for: .normal)}
    lazy var askBtn = UIButton() --> {$0.setImage(UIImage(named: "ask"), for: .normal)}
    lazy var backBtn = UIButton() --> {$0.setImage(UIImage(named: "backAction"), for: .normal)}
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
        layer.cornerRadius = 52/2
    }
    
    func prepareSubs(type: TopElementType) {
        switch type {
        case.title3btn:
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.height.equalTo(24)
            }
            stack.addArrangedSubview(plusBtn)
            stack.addArrangedSubview(qrcodeBtn)
            stack.addArrangedSubview(askBtn)
            
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.right.lessThanOrEqualTo(stack)
            }
            
        case .title2btn:
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.height.equalTo(24)
            }
            stack.addArrangedSubview(plusBtn)
            stack.addArrangedSubview(qrcodeBtn)
            
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.height.equalTo(30)
                make.right.lessThanOrEqualTo(stack)
            }
            addSubview(stack)
        case .backTitleLogo:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.size.equalTo(24)
            }
            addSubview(logo)
            logo.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(5)
                make.size.equalTo(38)
            }
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.center.equalToSuperview()
                make.left.lessThanOrEqualTo(backBtn.snp.right).offset(10)
                make.right.lessThanOrEqualTo(logo.snp.left).offset(10)
            }
        case .back:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.size.equalTo(24)
            }
        case .title:
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.center.equalToSuperview()
                make.left.equalToSuperview().inset(15)
                make.right.equalToSuperview().inset(15)
            }
        case .backTitle:
            addSubview(backBtn)
            backBtn.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
                make.size.equalTo(24)
            }
            addSubview(titleLbl)
            titleLbl.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.center.equalToSuperview()
                make.left.lessThanOrEqualTo(backBtn)
                make.right.equalToSuperview().inset(10)
            }
        }
        self.layoutIfNeeded()
    }
    
}
