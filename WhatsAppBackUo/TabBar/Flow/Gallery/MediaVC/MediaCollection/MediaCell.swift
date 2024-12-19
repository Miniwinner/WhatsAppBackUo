import UIKit
import SnapKit

class MediaCell: UICollectionViewCell {
    
    let label = UILabel() --> {
        $0.textColor = .white
        $0.backgroundColor = .black
        $0.textAlignment = .center
        $0.text = "None"
        $0.font = .custom(type: .glSemiBold, size: 24)
    }
    
    private var mediaView: MediaView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWhite()
        layer.cornerRadius = 32
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        label.removeFromSuperview()
//        label.text = nil
    }
    
    
    func checkFileType(_ path: String) {
        let url = URL(fileURLWithPath: getFilePath(path: path))

        switch url.pathExtension.lowercased() {
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff":
            mediaView = MediaView(type: .photo, path: url)
        case "mp4", "mov", "avi", "mkv", "webm":
            mediaView = MediaView(type: .video, path: url)
        case "mp3", "wav", "m4a", "aac", "flac", "opus":
            mediaView = MediaView(type: .audio, path: url)
        default:
            print("Unknown media type for file: \(url.pathExtension)")
        }
        print(url)
        addSubview(mediaView)
        mediaView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
