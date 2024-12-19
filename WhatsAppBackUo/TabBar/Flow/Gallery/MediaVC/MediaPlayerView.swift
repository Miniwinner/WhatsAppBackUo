import UIKit
import AVKit
import SnapKit
class MediaPlayerView: UIView {
    
    var playerViewController: AVPlayerViewController!
    var player: AVPlayer!
    var videoURL: URL!
    var isPlaing: Bool = false
    var tapping: Bool = false
    
    var hideBtnOperation: DispatchWorkItem?
    
    let stack = UIStackView() --> {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    let btnForward = UIButton() --> {
        $0.setImage(UIImage(named: "forward"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 54/2
    }
    
    let btnPausePlay = UIButton() --> {
        $0.setImage(UIImage(named: "play"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 54/2
    }
    
    let btnBack = UIButton() --> {
        $0.setImage(UIImage(named: "backward"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 54/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareStuff()
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayer(url: URL) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showBtnsCaller))
        player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.view.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 25, alphac: 1)
        
        insertSubview(playerViewController.view, at: 0)
        playerViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
        playerViewController.view.addGestureRecognizer(gesture)
        //        player.play()
        setupNotification()
    }
    
}

private extension MediaPlayerView {
    
    @objc func showBtnsCaller() {
        showBtns()
        if player.rate != 0 {
            hideBtns()
        }
    }
    
    @objc func forwardTenSecs() {
        showBtns()
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: 1))
        player.seek(to: newTime)
        hideBtns()
    }
    
    @objc func backWardTenSecs() {
        showBtns()
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTimeMakeWithSeconds(10, preferredTimescale: 1))
        player.seek(to: newTime)
        hideBtns()
    }
    
    @objc func playPauseAction() {
        showBtns()
        if player.rate == 0 {
            player.play()
            btnPausePlay.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player.pause()
            btnPausePlay.setImage(UIImage(named: "play"), for: .normal)
        }
        hideBtns()
    }
    
    @objc private func videoDidEnd() {
        hideBtnOperation?.cancel()
        print("Видео закончилось!")
        player.seek(to: .zero)
        btnPausePlay.setImage(UIImage(named: "play"), for: .normal)
        stack.alpha = 1
    }
    
}

private extension MediaPlayerView {
    
    private func setupNotification() {
        // Добавляем наблюдателя за окончанием видео
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    func showBtns() {
        UIView.animate(withDuration: 0.3) {
            self.stack.alpha = 1
        }
    }
    
    func hideBtns() {
        hideBtnOperation?.cancel()
        
        // Создаем новый WorkItem
        let workItem = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 1) {
                self?.stack.alpha = 0
            }
        }
        
        // Сохраняем текущий WorkItem
        hideBtnOperation = workItem
        
        // Запускаем его с задержкой в 10 секунд
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
    
    func prepareSubs() {
        makeWhite()
        layer.cornerRadius = 32
        clipsToBounds = true
        btnForward.addTarget(self, action: #selector(forwardTenSecs), for: .touchUpInside)
        btnPausePlay.addTarget(self, action: #selector(playPauseAction), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(backWardTenSecs), for: .touchUpInside)
        
        
    }
    
    func prepareStuff() {
        
        addSubview(stack)
        stack.addArrangedSubview(btnBack)
        stack.addArrangedSubview(btnPausePlay)
        stack.addArrangedSubview(btnForward)
        for view in stack.arrangedSubviews {
            view.snp.makeConstraints { make in
                make.width.equalTo(54)
            }
        }
        
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(60)
        }
    }
    
}
