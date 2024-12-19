import UIKit
import SnapKit

enum BoardType {
    case textOnTop
    case textOnBottom
}

final class BoardView: UIView {

    let imageHolder = UIView() --> {
        $0.layer.cornerRadius = 36
        $0.makeWhite()
    }
    
    var image: UIImage?
    
    let imageContainer = UIImageView() --> {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 24
    }
    
    let lblDesk = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    init(type: BoardType, model: OnboardingModel) {
        super.init(frame: .zero)
        prepareSubs(type: type, model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BoardView {
    
    func prepareSubs(type: BoardType, model: OnboardingModel) {
        image = UIImage(named: model.image)
        imageContainer.image = image
        
        addSubview(imageHolder)
       
        imageHolder.addSubview(imageContainer)
        
        addSubview(lblDesk)
        lblDesk.text = model.text
        switch type {
        case.textOnBottom:
            imageHolder.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.top.equalToSuperview()
            }
            
            imageContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
                make.height.equalTo(image?.size.height ?? 0)
            }
            
            lblDesk.snp.makeConstraints { make in
                make.top.equalTo(imageHolder.snp.bottom).offset(60)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            
        case .textOnTop:
            imageHolder.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            lblDesk.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(imageHolder.snp.top).inset(-20)
            }
            
            imageContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
                make.height.equalTo(image?.size.height ?? 0)
            }
        }
        
    }
    
}
