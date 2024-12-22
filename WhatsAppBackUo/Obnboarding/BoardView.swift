import UIKit
import SnapKit

enum BoardType {
    case textOnTop
    case textOnBottom
}

final class BoardView: UIView {

    let imageHolder = UIView() --> {
        $0.layer.cornerRadius = UIDevice.pad ? 50:36
        $0.makeWhite()
    }
    
    var image: UIImage?
    
    let imageContainer = UIImageView() --> {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = UIDevice.pad ? 40:24
    }
    
    let lblDesk = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 30:18)
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
        let imageHeight = image!.size.height
        let padHeight = imageHeight * 2.3
        let heightCalc = UIDevice.pad ? padHeight: imageHeight
        imageHolder.addSubview(imageContainer)
        
        let imageWidth = image!.size.width
        let padWidth = imageWidth * 2.3
        let widthCalc = UIDevice.pad ? padWidth : imageHeight
        
        addSubview(lblDesk)
        lblDesk.text = model.text
        switch type {
        case.textOnBottom:
            imageHolder.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(16)
            }
            
            imageContainer.snp.makeConstraints { make in
//                make.horizontalEdges.equalToSuperview().inset(120)
//                make.top.equalToSuperview().inset(100)
                make.height.equalTo(heightCalc)
                make.width.equalTo(widthCalc)
                make.edges.equalToSuperview().inset(10)
                
            }
            
            lblDesk.snp.makeConstraints { make in
//                make.top.equalTo(imageHolder.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.top.equalTo(imageHolder.snp.bottom).offset(20)
//                make.bottom.equalToSuperview().inset(40)

            }
            
            
        case .textOnTop:
            imageHolder.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            lblDesk.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(imageHolder.snp.top).inset(UIDevice.pad ? -40:-20)
            }
            
            imageContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(15)
                make.height.equalTo(heightCalc)
            }
        }
        
    }
    
}
