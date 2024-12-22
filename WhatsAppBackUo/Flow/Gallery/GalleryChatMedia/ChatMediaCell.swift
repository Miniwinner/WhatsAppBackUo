import UIKit
import SnapKit

class ChatMediaCell: UICollectionViewCell {
    
    private var mediaView: UniversalFormatView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWhite()
        prepareCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

    func setupMedia(path: String) {
        let url = URL(fileURLWithPath: path)
        
      
        switch url.pathExtension.lowercased() {
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff":
            mediaView = UniversalFormatView(type: .photo)
            if let image = UIImage(contentsOfFile: getFilePath(path: path)) {
                DispatchQueue.main.async {
                    
                    self.mediaView?.loadedImage.image = image
                }
            } else {
                print("Failed to load image from path: \(url)")
            }
        case "mp4", "mov", "avi", "mkv", "webm":
            mediaView = UniversalFormatView(type: .video)
        case "mp3", "wav", "m4a", "aac", "flac", "opus":
            mediaView = UniversalFormatView(type: .audio)
        default:
            mediaView = UniversalFormatView(type: .unknown)
            print("Unknown media type for file: \(url.pathExtension)")
        }
        addSubview(mediaView)
        mediaView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }


    
}


private extension ChatMediaCell {
    
    func prepareCell() {
        layer.cornerRadius = UIDevice.pad ? 42:36
        backgroundColor = .white.withAlphaComponent(0.6)
    }
    
}
