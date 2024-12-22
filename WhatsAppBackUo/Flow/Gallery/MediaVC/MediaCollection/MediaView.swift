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

    lazy var audioHolder = MediaAudioPlayer(type: .player)
    
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
            urlTypeAudio(url: path)
        case .photo:
            urlTypePhoto(path: path.path)
        case .video:
            urlTypeVideo(path: path)
        case .docs:
            break
        }
        
    }
    
    func urlTypeVideo(path: URL) {
        addSubview(videoHolder)
        videoHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        videoHolder.setupPlayer(url:path)
//        layoutIfNeeded()
    }
    
    func urlTypePhoto(path: String) {
       
        addSubview(photoHolder)
        photoHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        let image = UIImage(contentsOfFile: path)
        photoHolder.image = image
//        layoutIfNeeded()
    }
    
    func urlTypeAudio(url: URL) {
        addSubview(audioHolder)
        audioHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        audioHolder.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        audioHolder.layer.cornerRadius = 32
        audioHolder.playPauseButton.makeWhite()
        audioHolder.playAudio(from: url)
        
    }
    
}

private extension MediaView {
    
    func prepareSubs() {
        
    }
    
}


