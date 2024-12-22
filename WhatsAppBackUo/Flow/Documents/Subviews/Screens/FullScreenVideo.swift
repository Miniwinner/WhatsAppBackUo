import SnapKit
import UIKit
import AVKit
final class FullScreenVideo: UIViewController {

    let playerContainer = MediaPlayerView(fullScreen: true)
    private var router: DocumentsRouter?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAll()
        prepareSubs()
        
    }
    
    @objc func close() {
        if router != nil {
            router?.returnToPreviuos(time: playerContainer.player.currentTime(), rate: playerContainer.player.rate)
        } else {
            dismiss(animated: true)
        }
    }

    @objc func closeGesture(_ gesture: UISwipeGestureRecognizer) {
        if router != nil {
            router?.returnToPreviuos(time: playerContainer.player.currentTime(), rate: playerContainer.player.rate)
        } else {
            dismiss(animated: true)
        }
    }
    
       
    
    
    
    func loadVideo(url: URL, manager: DocumentsRouter, rate: Float, time: CMTime) {
        manager.fromVC = self
        self.router = manager
        playerContainer.setupPlayer(url: url)
        playerContainer.player.seek(to:time)
        playerContainer.player.rate = rate
        if rate == 0 {
            playerContainer.stack.alpha = 1
        } else {
            playerContainer.stack.alpha = 0
        }
    }
    
    func loadViaURL(url: URL) {
        playerContainer.setupPlayer(url: url)
    }
    
}

private extension FullScreenVideo {
    
    func prepareAll() {
        playerContainer.closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeGesture(_:)))
        swipeDownGesture.direction = .down
        view.addGestureRecognizer(swipeDownGesture)
    }
    
    func prepareSubs() {
        view.addSubview(playerContainer)
        playerContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
      
    }
}
