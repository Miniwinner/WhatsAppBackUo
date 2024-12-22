import SnapKit
import UIKit

final class NoContentView: UIView {
    
    let lblTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBold, size: UIDevice.pad ? 36:24)
        $0.text = "Oops, here is empty"
        $0.textAlignment = .center
    }
    
    let lblSubTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glRegular, size: UIDevice.pad ? 28:16)
        $0.text = "Read the instructions on how to import chats by clicking on the button at the top"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let noChatsImage = UIImageView(image: UIImage(named: "nochats"))
    
    override init (frame: CGRect) {
        super.init(frame: .zero)
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubs() {
        addSubview(noChatsImage)
        noChatsImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(UIDevice.pad ? 150:100)
            make.centerX.equalToSuperview()
        }
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(noChatsImage.snp.bottom).offset(UIDevice.pad ? 25:15)
            make.horizontalEdges.equalToSuperview()
            
        }
        addSubview(lblSubTitle)
        lblSubTitle.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(UIDevice.pad ? 25:15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
