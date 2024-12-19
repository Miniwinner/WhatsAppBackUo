import SnapKit
import UIKit

class LockTab: UIView {
    
    let textHolder = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBold, size: 35)
        $0.text = ""
        $0.textAlignment = .center
    }
    
    let num = 0 --> { number in
        print("number - \(number)")
    }
    
    let bottomLine = UIView() --> {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 2
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        self.textHolder.text = text
    }
    
    private func prepareView() {
        addSubview(textHolder)
        textHolder.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(textHolder.snp.bottom).offset(3)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(48)
        }
    }
    
}
