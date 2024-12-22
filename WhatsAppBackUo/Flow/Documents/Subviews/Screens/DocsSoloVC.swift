import UIKit
import SnapKit
import AVKit

final class DocsSoloVC: VcWithBackGround {

    private var url: URL?
    private var router: DocumentsRouter?
    
    lazy var videoHolder: MediaPlayerView = .init(withTimeLine: true)
    
    lazy var imageHolder = UIImageView() --> {
        $0.layer.cornerRadius = 32
        $0.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let holderContent = UIView() --> {
        $0.makeWhite()
        $0.layer.cornerRadius = 32
    }
    
    lazy var docsHolder = UIView() --> {
        $0.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        $0.layer.cornerRadius = 32
    }
    
    lazy var audioHolder: MediaAudioPlayer = .init(type: .docs)
    
    private var bottomBar: BottomBarView!
  
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitleLogo)
        topElement.title = lblTitle
        managers()
        super.viewDidLoad()
        
    }
    
    func playerSetTime(time: CMTime, rate: Float) {
        videoHolder.player.seek(to: time)
        videoHolder.player.rate = rate
        if rate == 0 {
            videoHolder.stack.alpha = 1
        } else {
            videoHolder.stack.alpha = 0
        }
    }
    
    func managers() {
        let router = DocumentsRouter()
        router.viewController = self
        self.router = router
    }
    
    func loadWithData(path: String) {
        let url = URL(fileURLWithPath: getFilePath(path: path))
        self.url = url
        print(url.lastPathComponent)
        lblTitle = url.lastPathComponent
        
        switch url.pathExtension {
        case "jpg", "jpeg", "png", "gif", "bmp", "tiff":
            dataIsPhoto(path: url.path)
        case "mp4", "mov", "avi", "mkv", "webm":
            dataIsVideo(url: url)
        case "mp3", "wav", "m4a", "aac", "flac", "opus":
            dataIsAudio(url: url)
        case "pdf":
            dataIsDocs(type: "docs")
//            dataIsPdf(url: url)
        case "txt":
            dataIsDocs(type: "txt")
//            dataIsPdf(url: url)
        default:
            dataIsDocs(type: "docs")
//            dataIsPdf(url: url)
            print("Unknown media type for file docs : \(url.pathExtension)")
        }
        bottomBar.shareBtn.addTarget(self, action: #selector(shareContent), for: .touchUpInside)
    }

    @objc func shareContent() {
        presentShareSheet(with: self.url!, from: self)
    }
    
    
    @objc func changeVolume() {
        guard let player = videoHolder.player else { return }
        if player.volume == 1 {
            player.volume = 0
            bottomBar.volumeBtn.setImage(UIImage(named: "volumeOff")!, for: .normal)
        } else {
            player.volume = 1
            bottomBar.volumeBtn.setImage(UIImage(named: "volume"), for: .normal)
        }
    }
    
    @objc func fullScreenCaller() {
        
        router?.showFullScreen(url: url!, router: router!,rate: videoHolder.player.rate,time: videoHolder.player.currentTime())
        videoHolder.player.pause()
    }
    
    
}

private extension DocsSoloVC {
    
    
    func dataIsPhoto(path: String) {
        bottomBar = BottomBarView(type: .photo)
        prepareSubs()
        holderContent.addSubview(imageHolder)
        imageHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        imageHolder.image = UIImage(contentsOfFile: path)
    }
    
    func dataIsVideo(url: URL) {
        holderContent.isHidden = true
        bottomBar = BottomBarView(type: .video)
        bottomBar.volumeBtn.addTarget(self, action: #selector(changeVolume), for: .touchUpInside)
        bottomBar.fullScreenBtn.addTarget(self, action: #selector(fullScreenCaller), for: .touchUpInside)
        prepareSubs()
     
        
        
        videoHolder.setupPlayer(url: url)
        view.addSubview(videoHolder)
        videoHolder.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomBar.snp.top).inset(-15)
        }
    }
    
    func dataIsAudio(url: URL) {
        bottomBar = BottomBarView(type: .audio)
        holderContent.isHidden = true
        prepareSubs()
        audioHolder.playAudio(from: url)
        view.addSubview(audioHolder)
        audioHolder.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomBar.snp.top).inset(-15)
        }
    }
    
    func dataIsDocs(type: String) {
        bottomBar = BottomBarView(type: .docs)
        prepareSubs()
        holderContent.addSubview(docsHolder)
        docsHolder.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        let view = UIImageView(image: UIImage(named: "\(type)image"))
        docsHolder.addSubview(view)
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(56)
        }
        let label = UILabel()
        label.textColor = . white
        label.textAlignment = .center
        label.font = .custom(type: .glSemiBold, size: 30)
        label.text = ".\(url!.pathExtension)"
        docsHolder.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(32)
        }
       
        
    }
    
    func dataIsPdf(url: URL) {
        let documentController = UIDocumentInteractionController(url: url)
        documentController.delegate = self as? UIDocumentInteractionControllerDelegate
        documentController.presentPreview(animated: true)
    }
    
    func prepareSubs() {
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        view.addSubview(holderContent)
        holderContent.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomBar.snp.top).inset(-15)
        }
    }
  
    func presentShareSheet(with fileURL: URL, from viewController: UIViewController) {
        let activityItems: [Any] = [fileURL]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList
        ]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
}
