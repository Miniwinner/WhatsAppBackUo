import UIKit
import SnapKit

class MediaView: UIView {

    lazy var photoHolder = UIImageView() --> {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 32
        $0.clipsToBounds = true
    }
    
    lazy var videoHolder: MediaPlayerView = .init()

    init(type: MediaTypeMine, path: URL) {
        super.init(frame: .zero)
        createMediaContainer(type: type, path: path)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MediaView {
    
    func createMediaContainer(type: MediaTypeMine, path: URL) {
        switch type {
        case .audio:
            print("audio")
        case .photo:
            urlTypePhoto(path: path.path)
        case .video:
            urlTypeVideo(path: path)
        }
        
    }
    
    func urlTypeVideo(path: URL) {
        addSubview(videoHolder)
        videoHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        videoHolder.setupPlayer(url:path)
        layoutIfNeeded()
    }
    
    func urlTypePhoto(path: String) {
       
        addSubview(photoHolder)
        photoHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        let image = UIImage(contentsOfFile: path)
        photoHolder.image = image
        layoutIfNeeded()
    }
    
}

private extension MediaView {
    
    func prepareSubs() {
        
    }
    
}


