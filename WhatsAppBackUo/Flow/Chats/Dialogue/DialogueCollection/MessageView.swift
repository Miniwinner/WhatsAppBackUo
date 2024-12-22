import UIKit
import SnapKit

enum MessageViewType {
    case sender
    case reciever
}

protocol MessageViewTapped: AnyObject {
    func procedTapToCell()
}

final class MessageView: UIView {
    
    weak var viewDelegate: MessageViewTapped?
    
    lazy var audioHolder = MediaAudioPlayer(type: .chat)
    
    lazy var dockContainer = UILabel() --> {
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 24:16)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        
    }
    let lblFileName = UILabel() --> {
        $0.layer.cornerRadius = UIDevice.pad ? 20:14
        $0.clipsToBounds = true
        $0.textAlignment = .center
        
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 22:12)
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    lazy var videoHolder = UIButton() --> {
        $0.setImage(UIImage(named: "playmess"), for: .normal)
        $0.layer.cornerRadius = 38
    }
    
    lazy var photoHolder = UIImageView() --> {
        $0.layer.cornerRadius = 38
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var lblMessage = UILabel() --> {
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 27:16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    init(type: MessageViewType, model: MessageModel) {
        super.init(frame: .zero)
        checkMessType(type: type, model: model)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkMessType(type:MessageViewType, model: MessageModel) {
        if model.contentType == .text {
            setupView(type: type, model: model)
        } else {
            setupMediaView(type: type, model: model)
        }
    }
    
    
    private func setupView(type: MessageViewType, model: MessageModel) {
        lblMessage.text = model.content
        layer.cornerRadius = UIDevice.pad ? 30:15
        switch type {
        case .sender:
            lblMessage.textColor = .white
            backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
        case .reciever:
            lblMessage.textColor = .black
            backgroundColor = .white
        }
        addSubview(lblMessage)
        lblMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(UIDevice.pad ? 20: 10)
        }
    }
    
    @objc func openVideo() {
        viewDelegate?.procedTapToCell()
    }
    
    
    private func setupMediaView(type: MessageViewType, model: MessageModel) {
        layer.cornerRadius = 50
        switch type {
        case .sender:
            backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
        case .reciever:
            backgroundColor = .white
        }
        
        
        
        let url = URL(fileURLWithPath: getFilePath(path: model.content))
        switch url.pathExtension  {
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff":
            
            switch type {
            case .sender:
                photoHolder.backgroundColor = .white
                backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            case .reciever:
                photoHolder.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
                backgroundColor = .white
            }
            
            dataPhoto(url: url.path)
        case "mp4", "mov", "avi", "mkv", "webm":
            dataVideo(url: url)
            
            switch type {
            case .sender:
                videoHolder.backgroundColor = .white
                videoHolder.tintColor = .white
                backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            case .reciever:
                videoHolder.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
                videoHolder.tintColor =  UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
                backgroundColor = .white
            }
        case "mp3", "wav", "m4a", "aac", "flac", "opus":
            dataAudio(url: url, sender: type)
        default:
            dataDock(url: url, sender: type)
            print("Unknown media type for file: \(url.pathExtension)")
            
        }
    }
    
    
    
}

private extension MessageView {
    
    func dataPhoto(url: String) {
        if let image = UIImage(contentsOfFile: url) {
            addSubview(photoHolder)
            photoHolder.snp.makeConstraints { make in
                let maxWidth: CGFloat = UIScreen.main.bounds.width - (UIDevice.pad ? 120:60)
                let maxHeight: CGFloat = UIDevice.pad ?  420:300 // Установите максимальную высоту, например, 300

                let aspectRatio = image.size.height / image.size.width
                
                // Вычисляем размеры, учитывая ограничения по ширине и высоте
                let adjustedWidth = min(image.size.width, maxWidth)
                var adjustedHeight = adjustedWidth * aspectRatio
                
                // Проверяем, не превышает ли высота максимальную высоту
                if adjustedHeight > maxHeight {
                    adjustedHeight = maxHeight
                }
                
                // Ограничиваем размеры photoHolder
                make.width.equalTo(adjustedWidth)
                make.height.equalTo(adjustedHeight)
                
                // Устанавливаем отступы
                make.edges.equalToSuperview().inset(10)
            }
        

            
            
            DispatchQueue.main.async {
                self.photoHolder.image = image
            }
        } else {
            addSubview(photoHolder)
            photoHolder.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIDevice.pad ? 20:10)
                make.size.equalTo(UIDevice.pad ? 310:210)
            }
        }
        
    }
    
    func dataVideo(url: URL) {
        addSubview(videoHolder)
        videoHolder.snp.makeConstraints { make in
            make.size.equalTo(UIDevice.pad ? 310:210)
            make.edges.equalToSuperview().inset(UIDevice.pad ? 20:10)
        }
        videoHolder.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
    }
    
    func dataDock(url:URL, sender: MessageViewType) {
        layer.cornerRadius = UIDevice.pad ? 30:20
        addSubview(dockContainer)
        addSubview(lblFileName)
        dockContainer.text = url.pathExtension.uppercased()
        lblFileName.text = url.lastPathComponent
        switch sender {
        case .reciever:
            dockContainer.snp.makeConstraints { make in
                make.size.equalTo(UIDevice.pad ? 84:54)
                make.left.equalToSuperview().inset(UIDevice.pad ? 10:5)
                make.centerY.equalToSuperview()
                make.verticalEdges.equalToSuperview().inset(UIDevice.pad ? 10:5)
            }
            lblFileName.snp.makeConstraints { make in
                make.left.equalTo(dockContainer.snp.right).offset(UIDevice.pad ? 10:5)
                make.right.equalToSuperview().inset(UIDevice.pad ? 10:5)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 24:20)
            }
            dockContainer.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            dockContainer.textColor = .white
            lblFileName.textColor = .black
        case .sender:
            dockContainer.snp.makeConstraints { make in
                make.size.equalTo(UIDevice.pad ? 84:53)
                make.right.equalToSuperview().inset(UIDevice.pad ? 10:5)
                make.centerY.equalToSuperview()
                make.verticalEdges.equalToSuperview().inset(UIDevice.pad ? 10:5)
            }
            lblFileName.snp.makeConstraints { make in
                make.right.equalTo(dockContainer.snp.left).offset(UIDevice.pad ? 10:5)
                make.left.equalToSuperview().inset(UIDevice.pad ? 10:5)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 24:20)
            }
            dockContainer.backgroundColor = .white
            dockContainer.textColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            lblFileName.textColor = .white
        }
    }
    
    func dataAudio(url: URL, sender: MessageViewType) {
        addSubview(audioHolder)
        audioHolder.layer.cornerRadius = UIDevice.pad ? 36:28
        audioHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        audioHolder.playAudio(from: url)
        audioHolder.playPauseButton.layer.cornerRadius = 54/2
        switch sender {
        case .reciever:
            audioHolder.backgroundColor = .white
            audioHolder.playPauseButton.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            audioHolder.playPauseButton.tintColor = .white
            audioHolder.timeLineView?.setReciever()
        case .sender:
            audioHolder.timeLineView?.setSender()
            audioHolder.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            audioHolder.playPauseButton.tintColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
            audioHolder .playPauseButton.backgroundColor = .white
        }
    }
    
}
