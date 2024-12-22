import UIKit
import AVKit
import SnapKit
class MediaPlayerView: UIView {
    
    private var playerViewController: AVPlayerViewController!
    var player: AVPlayer!
    
    private var withTimeLine: Bool = false
    
    var timeLineView: TImeLineView!
    var hideBtnOperation: DispatchWorkItem?
    
    lazy var fullScreen: Bool = false
    
    lazy var duration: Float = 0
    
    lazy var previousTime: Float = 0.0
    
    lazy var view = UIView()
    
    lazy var closeBtn = UIButton() --> {
        $0.setImage(UIImage(named: "previousMedia"), for: .normal)
        $0.alpha = 1
        $0.makeWhite()
        $0.layer.cornerRadius = 20
    }
    
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
    
    init(withTimeLine: Bool = false, fullScreen: Bool = false) {
        super.init(frame: .zero)
        if withTimeLine {
            timeLineView = TImeLineView(type: .docs)
        } else {
            timeLineView = TImeLineView(type: .player)
        }
        self.withTimeLine = withTimeLine
        self.fullScreen = fullScreen
        prepareStuff()
        prepareSubs()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setupPlayer(url: URL) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showBtnsCaller))
        player = AVPlayer(url: url)
        player.volume = 1.0
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки аудиосессии: \(error)")
        }
        playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.view.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 25, alphac: 1)
        playerViewController.view.addGestureRecognizer(gesture)
        playerViewController.view.layer.cornerRadius = 32
        setupNotification()
        
        if withTimeLine {
            let asset = AVURLAsset(url: url)
            let duration = CMTimeGetSeconds(asset.duration)
            let durationForametted = formattedTime(from: duration)
            self.duration = Float(duration)
            timeLineView.rightLbl.text = durationForametted
            player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
        
                guard let self = self else { return }
                
                let currentTime = CMTimeGetSeconds(time)
                
                if self.timeHasChanged(Float(currentTime)) {
                    self.handleTimeChange(Float(currentTime), seconds: self.player.currentItem?.duration.seconds ?? 1)
                    
                    self.previousTime = Float(currentTime)
                }
            }
        }
        needTimeLine()
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
        
        btnPausePlay.setImage(UIImage(named: "play"), for: .normal)
        stack.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.player.seek(to: .zero)
        }
    }
    
}

private extension MediaPlayerView {
    
    private func timeHasChanged(_ currentTime: Float) -> Bool {
        return abs(currentTime - previousTime) > 0.1
    }
    
    private func handleTimeChange(_ currentTime: Float, seconds: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.timeLineView.updateFillFrame(currentTime: currentTime, duration: seconds)
            
            
        }
        
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    func showBtns() {
        UIView.animate(withDuration: 0.3) {
            self.stack.alpha = 1
            self.closeBtn.alpha = 1
        }
    }
    
    func hideBtns() {
        hideBtnOperation?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 1) {
                self?.stack.alpha = 0
                self?.closeBtn.alpha = 0
            }
        }
        hideBtnOperation = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }
    
    func needTimeLine() {
        if withTimeLine {
            addSubview(timeLineView)
            timeLineView.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(40)
            }
            
            
            view.makeWhite()
            view.layer.cornerRadius = 32
            view.snp.makeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(timeLineView.snp.top).inset(-15)
            }
            view.addSubview(playerViewController.view)
            playerViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
                
            }
        } else {
            if fullScreen {
                playerViewController.view.layer.cornerRadius = 0
            } else {
                makeWhite()
            }
            insertSubview(playerViewController.view, at: 0)
            playerViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                
            }
        }
        
    }
    
    func prepareSubs() {
        layer.cornerRadius = 32
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
        if withTimeLine {
            insertSubview(view, at: 0)
        }
        
        stack.snp.makeConstraints { make in
            if withTimeLine {
                make.centerY.equalTo(view)
            } else {
                make.centerY.equalToSuperview()
            }
            make.height.equalTo(54)
            make.horizontalEdges.equalToSuperview().inset(60)
        }
        if fullScreen {
            addSubview(closeBtn)
            closeBtn.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(40)
                make.left.equalToSuperview().inset(20)
                make.size.equalTo(40)
            }
        }
    }
    
}
