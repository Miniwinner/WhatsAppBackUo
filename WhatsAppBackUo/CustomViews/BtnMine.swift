
import UIKit

class BtnMine: UIButton {

    let imageViewMine = UIImageView() --> {
        $0.backgroundColor = .clear
    }
        
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(imageViewMine)
        imageViewMine.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(UIDevice.pad ? 40:24)
        }
        self.addTarget(self, action: #selector(animateImage), for: .touchUpInside)
        
    }
    
    @objc func animateImage() {
        self.imageViewMine.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.imageViewMine.alpha = 1
        }
        

    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
