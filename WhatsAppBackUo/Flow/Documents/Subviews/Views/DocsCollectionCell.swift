import UIKit
import SnapKit

final class DocsCollectionCell: UICollectionViewCell {
    
    let lblTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBlack, size: 16)
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }
    
    let contentType = UIImageView() --> {
        $0.backgroundColor = .clear
    }
    
    let lblDate = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 12)
        $0.textAlignment = .center
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWhite()
        layer.cornerRadius = 36
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithData(path: String) {
        let url = URL(fileURLWithPath: getFilePath(path: path))
        var imageName: String = ""
        switch url.pathExtension.lowercased() {
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff":
            imageName = "photo"
        case "mp4", "mov", "avi", "mkv", "webm":
            imageName = "video"
        case "mp3", "wav", "m4a", "aac", "flac", "opus":
            imageName = "audio"
        case "txt":
            imageName = "txt"
        case "pdf":
            imageName = "pdf"
        default:
            imageName = "docs"
            print("Unknown media type for file: \(url.pathExtension)")
        }
        let image = UIImage(named: "\(imageName)image")
        contentType.image = image
        lblTitle.text = url.lastPathComponent
        lblDate.text = extractAndFormatDate(from: path)
    }
    
}

private extension DocsCollectionCell {
    
    func prepareSubs() {
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalToSuperview().inset(7)
        }
        addSubview(contentType)
        contentType.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(3)
            make.height.equalTo(40)
            make.width.equalTo(42)
            make.centerX.equalToSuperview()
        }
        addSubview(lblDate)
        lblDate.snp.makeConstraints { make in
            make.top.equalTo(contentType.snp.bottom).offset(3)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(7)
        }
    }
    
}
