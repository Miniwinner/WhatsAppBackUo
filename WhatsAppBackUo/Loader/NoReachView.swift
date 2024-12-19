import UIKit
import SnapKit

final class NoReachView: UIView {
    
    let imageWarning: UIImageView = .init(image: UIImage(named: "warning"))
    let lblTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBlack, size: 24)
        $0.text = "Oops, no internet connection!"
        $0.textAlignment = .center
    }
    
    let lblSubTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glRegular, size: 16)
        $0.text = "Make sure wifi is turned on and then try again"
        $0.textAlignment = .center
    }
    
    let btnNext = UIButton() --> { button in
        button.setImage(UIImage(named: "next"), for: .normal)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .custom(type: .glRegular, size: 20)
        button.layer.cornerRadius = 22
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NoReachView {
    
    func prepareSubs() {
        addSubview(imageWarning)
        imageWarning.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(100)
            make.centerX.equalToSuperview()
        }
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(imageWarning.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
        addSubview(lblSubTitle)
        lblSubTitle.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(18)
        }
        addSubview(btnNext)
        btnNext.snp.makeConstraints { make in
            make.top.equalTo(lblSubTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
    
}
