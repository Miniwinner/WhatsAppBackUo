import UIKit
import SnapKit

final class BottomBarView: UIView {

    var itemsCount: Int = 1
    
    lazy var fullScreenBtn = UIButton() --> {
        $0.setImage(UIImage(named: "full"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 44/2
    }
    
    lazy var miniScreenBtn = UIButton() --> {
        $0.setImage(UIImage(named: "unfull"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 44/2
    }
    
    lazy var volumeBtn = UIButton() --> {
        $0.setImage(UIImage(named: "volume"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 44/2
    }
    
    lazy var shareBtn = UIButton() --> {
        $0.setImage(UIImage(named: "activity"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 44/2
    }
    
    let stack = UIStackView() --> {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 20
        
    }
    

    
    init(type: MediaTypeMine) {
        super.init(frame: .zero)
        prepareBtns(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension BottomBarView {
    func prepareBtns(type: MediaTypeMine) {
        addSubview(stack)
        
        switch type {
        case.video:
            stack.addArrangedSubview(fullScreenBtn)
            stack.addArrangedSubview(miniScreenBtn)
            stack.addArrangedSubview(volumeBtn)
            itemsCount = 4
        case .photo:
            itemsCount = 3
        case .audio:
            itemsCount = 3
        case .docs:
           1
        }
        stack.addArrangedSubview(shareBtn)
        for view in stack.arrangedSubviews {
            view.snp.makeConstraints { make in
                make.width.equalTo(44)
            }
        }
        
        stack.snp.makeConstraints { make in
//            make.width.lessThanOrEqualTo(self.frame.width).priority(.medium)
//            make.width.greaterThanOrEqualTo(44).priority(.low)
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        
    }
}
