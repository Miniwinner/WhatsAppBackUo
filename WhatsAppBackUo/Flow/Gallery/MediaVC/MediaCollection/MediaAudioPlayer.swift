import UIKit
import AVKit
import ffmpegkit
import SnapKit

final class MediaAudioPlayer: UIView, AVAudioPlayerDelegate {
    
    private var player: AVAudioPlayer?
    var timeLineView: TImeLineView?
    
    lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.layer.cornerRadius = 27
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private var type: TimeLineType = .chat
    
    lazy var previousTime: Float = 0.0
    private var timer: Timer?
    
    init(type: TimeLineType) {
        super.init(frame: .zero)
        self.type = type
        setupPlayer(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio finished playing.")
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        player.currentTime = 0
        DispatchQueue.main.async {
                    self.timeLineView?.updateFillFrame(currentTime: Float(player.duration), duration: player.duration, forceFullWidth: true)
        }
        timer?.invalidate()
    }
    
    // MARK: - Public Methods
    func playAudio(from url: URL) {
        if url.pathExtension.lowercased() == "opus" {
            convertAndPlayOpusFile(from: url)
        } else {
            prepareAudioPlayer(with: url)
            
        }
    }
    
    @objc private func togglePlayPause() {
        guard let player = player else { return }
        
        if player.isPlaying {
            timer?.invalidate()
                player.pause()
            
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            
        } else {
            addAudioTimeChecker()
                player.play()
            
            
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
        }
    }
    
    // MARK: - Private Methods
    private func setupPlayer(for type: TimeLineType) {
        
        switch type {
        case .player:
            addSubview(playPauseButton)
            playPauseButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(54)
            }
        case .chat:
            addSubview(playPauseButton)

            timeLineView = TImeLineView(type: .chat)
            configureChatPlayerLayout()
        case .docs:
            timeLineView = TImeLineView(type: .docs)
            configureSimplePlayerLayout()
        }
    }
    
    private func configureSimplePlayerLayout() {
        guard let timeLineView = timeLineView else { return }
        addSubview(timeLineView)
        let holder = UIView()
        holder.makeWhite()
        holder.layer.cornerRadius = 32
        addSubview(holder)
        let holder2 = UIView()
        holder.addSubview(holder2)
        holder2.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
        holder2.layer.cornerRadius = 28
        holder2.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        holder.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(timeLineView.snp.top).inset(-20)
        }
        holder2.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(54)
        }
        timeLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func configureChatPlayerLayout() {
        guard let timeLineView = timeLineView else { return }
        addSubview(timeLineView)
        playPauseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(54)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
        timeLineView.snp.makeConstraints { make in
            make.left.equalTo(playPauseButton.snp.right).offset(5)
            make.right.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
//            make.width.equalTo(100)
            make.height.equalTo(54)
        }
    }
    
    private func addAudioTimeChecker() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            
            let currentTime = Float(player.currentTime)
            let duration = player.duration
            
            if self.timeHasChanged(currentTime) {
                self.handleTimeChange(currentTime, seconds: duration)
                self.previousTime = currentTime
            }
        }
    }
    
    private func timeHasChanged(_ currentTime: Float) -> Bool {
        return abs(currentTime - previousTime) > 0.1
    }
    
    private func handleTimeChange(_ currentTime: Float, seconds: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if abs(currentTime - Float(seconds)) < 0.1 {
                self.timeLineView?.updateFillFrame(currentTime: Float(seconds), duration: seconds, forceFullWidth: true)
            } else {
                self.timeLineView?.updateFillFrame(currentTime: currentTime, duration: seconds)
            }
        }
    }

    
    private func prepareAudioPlayer(with url: URL) {
        do {
            if player != nil {
                player?.stop()
            }
            let duration = getAudioDuration(from: url)
            let formattedDuration = formattedTime(from: duration)
            updateTimeline(for: duration, formattedDuration: formattedDuration)
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.volume = 1
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            print("Audio prepared for playback: \(url.path)")
        } catch {
            print("Error preparing audio player: \(error.localizedDescription)")
        }
    }
    
    private func updateTimeline(for duration: Double, formattedDuration: String) {
        guard let timeLineView = timeLineView else { return }
        DispatchQueue.main.async {
            timeLineView.rightLbl.text = formattedDuration
        }
        if type == .chat {
           
            
            let width: CGFloat = CGFloat(max(100, Int(duration * 5)))
            DispatchQueue.main.async {
                
                
                timeLineView.timeLineEmpty.snp.remakeConstraints { make in
                    make.width.equalTo(width)
                    make.left.equalTo(self.playPauseButton.snp.right).offset(5)
                    make.right.equalToSuperview().inset(10)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(6)
                }
                
                timeLineView.layoutIfNeeded()
                
                
            }
        }
    }
    
    private func convertAndPlayOpusFile(from url: URL) {
        let outputPath = NSTemporaryDirectory() + "output.wav"
        let command = "-y -i \(url.path) -f wav \(outputPath)"
        
        print("Executing FFmpeg command: \(command)")
        
        FFmpegKit.executeAsync(command) { [weak self] session in
            guard let self = self else { return }
            guard let returnCode = session?.getReturnCode(), ReturnCode.isSuccess(returnCode) else {
                print("Error converting OPUS file.")
                return
            }
            
            let outputURL = URL(fileURLWithPath: outputPath)
            if FileManager.default.fileExists(atPath: outputURL.path) {
                print("Converted file found: \(outputURL.path)")
                self.prepareAudioPlayer(with: outputURL)
            } else {
                print("Error: Converted file not found.")
            }
        }
    }
    
    private func getAudioDuration(from url: URL) -> Double {
        let asset = AVURLAsset(url: url)
        return CMTimeGetSeconds(asset.duration)
    }
}
