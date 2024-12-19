import UIKit
import SnapKit

final class BtnTop: UIButton {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
