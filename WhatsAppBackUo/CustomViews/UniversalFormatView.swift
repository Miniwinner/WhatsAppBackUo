import UIKit
import SnapKit

enum MediaViewType {
    case photo
    case video
    case audio
    case docs
    case unknown
}

final class UniversalFormatView: UIView {

    lazy var loadedImage = UIImageView() --> {
        $0.contentMode = .scaleAspectFill
//        $0.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        $0.backgroundColor = .clear

    }
    
    lazy var mediaTypeBtn = UIImageView() --> {
        $0.contentMode = .scaleAspectFit
    }
    
    init(type: MediaViewType) {
        super.init(frame: .zero)
        prepareViewSelf()
        prepareView(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension UniversalFormatView {
    
    func prepareViewSelf() {
        backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        layer.cornerRadius = UIDevice.pad ? 40:32
        clipsToBounds = true
    }
    
    func prepareView(type: MediaViewType) {
        switch type {
        case .photo:
            addSubview(loadedImage)
            loadedImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .video:
            addSubview(loadedImage)
            loadedImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            addSubview(mediaTypeBtn)
            mediaTypeBtn.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 88:52)
                make.width.equalTo(UIDevice.pad ? 108:64)
            }
            mediaTypeBtn.image = UIImage(named: "video")
           
        case .audio:
            addSubview(mediaTypeBtn)
            mediaTypeBtn.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 88:52)
                make.width.equalTo(UIDevice.pad ? 108:64)
            }
            mediaTypeBtn.image = UIImage(named: "audio")
           
        default:
            break
        }
        
    }
}
