import UIKit
import AVFoundation
import AVKit

protocol UICVideoPlayerViewDelegate: class {
    func dismiss(_ videoView: AVOVideoPlayerView)
}


class AVOVideoPlayerView: UIView {
    
    var didTapInfoButton: (()->())?
    var didTapRewindButton: (()->())?
    var didTapForwardButton: (()->())?
    var didVideoInFullScreen: (()->())?
    var didPassed1Minute: (()->())?

    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
    
    enum KeyPath: String {
        case Status = "status"
        case TimeControl = "timeControlStatus"
        case LoadedTimeRange = "currentItem.loadedTimeRanges"
    }
    
    private var session = AVAudioSession.sharedInstance()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    private var selectedBitRate: Double = 512.0
    private var isMuted: Bool = false
    private var isPlaying: Bool = false
    private var isFirstPlaying: Bool = true
    private var isControlContainerViewShowing: Bool = false
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var controlContainerView: UIView!

    @IBOutlet weak var infoButton: UIButton!

    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var rewindButton: UIButton!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var muteButton: UIButton!
    
    @IBOutlet weak var bitRateButton: UIButton!
    
    @IBOutlet weak var videoLenghtLabel: UILabel!
    
    @IBOutlet weak var timeSepratorLabel: UILabel!
    
    @IBOutlet weak var passedTimeLabel: UILabel!
    
    @IBOutlet weak var errorlabel: UILabel!
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    private var playerController: AVPlayerViewController!
        
    
    private lazy var setupBufferLoadAnimation: CABasicAnimation = {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.repeatCount = 0
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        return basicAnimation
    }()
    
    private lazy var bufferLoadRangeLayer: CAShapeLayer = {
        let animationLayer = CAShapeLayer()
        animationLayer.lineWidth = 3
        animationLayer.strokeColor = UIColor.white.cgColor
        animationLayer.lineCap = .square
        animationLayer.strokeEnd = 0
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: timeSlider.bounds.minX + 3, y: timeSlider.bounds.midY))
        path.addLine(to: CGPoint(x: timeSlider.bounds.maxX, y: timeSlider.bounds.midY))
        animationLayer.path = path.cgPath
        timeSlider.layer.insertSublayer(animationLayer, at: 0)
        animationLayer.add(setupBufferLoadAnimation, forKey: "strokeEndAnimation")
        return animationLayer
    }()
    

    
    public var videoLink: String = "" {
        didSet {
            if isPlaying { pauseVideo() }
            setupPlayer(with: videoLink)
        }
    }
    
    public var isLiveStream = false
    public var ownerViewController: UIViewController?
    public weak var delegate: UICVideoPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("AVOVideoPlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        timeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        timeSlider.setThumbImage(UIImage(named: "sliderThumb"), for: .highlighted)
        
        controlContainerView.isHidden = true
        self.isUserInteractionEnabled = false

    }
    
    private func setupPlayer(with urlString: String) {

        if let url = URL(string: urlString) {
            errorlabel.isHidden = true
            videoLenghtLabel.isHidden = true
            timeSepratorLabel.isHidden = true
            
            isControlContainerViewShowing = false
            self.isUserInteractionEnabled = true
            
//            bitRateButton.isHidden = !isLiveStream
            
            // Remove observer for tracking player buffering status
            player?.removeObserver(self, forKeyPath: KeyPath.TimeControl.rawValue)
            
            // Remove observer for tracking player time details
            player?.removeObserver(self, forKeyPath: KeyPath.LoadedTimeRange.rawValue)
            
            // Remove observer for tracking player load status
            playerItem?.removeObserver(self, forKeyPath: KeyPath.Status.rawValue)
            
            // Remove observer for tracking player playback ends
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            
            // Create AVPlayer object
            let asset = AVAsset(url: url)
            playerItem = AVPlayerItem(asset: asset)
            playerItem?.preferredPeakBitRate = selectedBitRate
            player = AVPlayer(playerItem: playerItem)
            
            // If there is a video layer thats mean user playing next video
            // So hide buttons, show loading spinner and show control view
            // Than remove old layer from view to add new layer.
            if playerLayer != nil {
                self.passedTimeLabel.text = "00:00"
                self.rewindButton.isHidden = true
                self.playPauseButton.isHidden = true
                self.forwardButton.isHidden = true
                self.loadingSpinner.startAnimating()
                self.handleTap()
                UIView.transition(with: self, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.playerLayer?.removeFromSuperlayer()
                }) { (_) in
                    self.playerLayer = nil
                    // Create AVPlayerLayer object
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer?.frame = self.bounds
                    self.playerLayer?.videoGravity = .resizeAspectFill
                    self.playerLayer?.name = "VideoLayer"
                    
                    // Add playerLayer to view's layer
                    self.layer.insertSublayer(self.playerLayer!, at: 0)
                }
            }
            
            else {
                
                // Create AVPlayerLayer object
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.frame = self.bounds
                playerLayer?.videoGravity = .resizeAspectFill
                playerLayer?.name = "VideoLayer"
                
                // Add playerLayer to view's layer
                self.layer.insertSublayer(playerLayer!, at: 0)
            }
            
            // Add observer for tracking current time value
            player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: .main) {[weak self] (progressTime) in
                
                // Get passed time for video (minute & seconds)
                if let weakSelf = self, let duration = weakSelf.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    let seconds = CMTimeGetSeconds(progressTime)
                    let progress = Float(seconds/durationSeconds)
                    
                    DispatchQueue.main.async {[weak self] in
                        self?.timeSlider.value = progress
                        let secondText = String(format: "%02d", Int(seconds) % 60)
                        let minuteText = String(format: "%02d", Int(seconds) / 60)
                        self?.passedTimeLabel.text = "\(minuteText):\(secondText)"
                        if (Int(seconds) / 60 == 1) && (Int(seconds) % 60 == 1) {
                            self?.didPassed1Minute?()
                        }
                        if progress >= 1.0 {
                            self?.timeSlider.value = 0.0
                            self?.passedTimeLabel.text = "00:00"
                        }
                    }
                }
            }
            
            // Add observer for tracking player buffering status
            player?.addObserver(self, forKeyPath: KeyPath.TimeControl.rawValue, options: [.old, .new], context: nil)
            
            // Add observer for tracking player time details
            player?.addObserver(self, forKeyPath: KeyPath.LoadedTimeRange.rawValue, options: [.old, .new], context: nil)
            
            // Add observer for tracking player load status
            playerItem?.addObserver(self, forKeyPath: KeyPath.Status.rawValue, options: [.old, .new], context: nil)
            
            // Add observer for tracking player playback ends
            NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            // Start playing video
            self.playVideo()
        }
    }
    
    private func avPlayerSetup() {
        do {
            try session.setCategory(AVAudioSession.Category.playback)
            try session.overrideOutputAudioPort(.none)
            try session.setActive(true)
        } catch {
            print("AVPlayer setup error \(error.localizedDescription)")
        }
    }
    
    // Mark: - Player & video status
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        // Current video loading details (is started to play or not)
        if keyPath == KeyPath.TimeControl.rawValue, let change = change,
            let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
            let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        
                        if self!.isFirstPlaying {
                            self?.isFirstPlaying = false
                            self?.controlContainerView.isHidden = true
                            self?.isControlContainerViewShowing = true
                        }
                        self?.rewindButton.isHidden = false
                        self?.playPauseButton.isHidden = false
                        self?.forwardButton.isHidden = false
                        self?.loadingSpinner.stopAnimating()
                    } else {
                        self?.rewindButton.isHidden = true
                        self?.playPauseButton.isHidden = true
                        self?.forwardButton.isHidden = true
                        self?.loadingSpinner.startAnimating()
                    }
                }
            }
        }
        
        // Current video time details (video lenght)
        
        if !isLiveStream, keyPath == KeyPath.LoadedTimeRange.rawValue {
            videoLenghtLabel.isHidden = false
            timeSepratorLabel.isHidden = false
            if let duration = player?.currentItem?.duration, duration != .indefinite {
                let seconds = CMTimeGetSeconds(duration)
                let secondText = String(format: "%02d", Int(seconds) % 60)
                let minuteText = String(format: "%02d", Int(seconds) / 60)
                DispatchQueue.main.async {[weak self] in
                    self?.videoLenghtLabel.text = "\(minuteText):\(secondText)"
                }
                
                if let timeRangeArray = player?.currentItem?.loadedTimeRanges {
                    let aTimeRange: CMTimeRange = timeRangeArray.first!.timeRangeValue
                    let startTime = CMTimeGetSeconds(aTimeRange.start)
                    let loadedDuration = CMTimeGetSeconds(aTimeRange.duration)
                    
                    DispatchQueue.main.async {[weak self] in
                        let bufferLoadedTime: CGFloat = CGFloat(startTime + loadedDuration) / 100
                        if bufferLoadedTime <= 1.0 {
                            self?.bufferLoadRangeLayer.strokeEnd = bufferLoadedTime
                        }
                    }
                }
            }
        }
        
        // Player loading status (is failed or unknown or ready to play)
        if keyPath == KeyPath.Status.rawValue {
            guard let status = player?.currentItem?.status else { return }
            if status == .failed || status == .unknown {
                DispatchQueue.main.async {[weak self] in
                    self?.rewindButton.isHidden = false
                    self?.playPauseButton.isHidden = false
                    self?.forwardButton.isHidden = false
                    self?.loadingSpinner.stopAnimating()
                    self?.controlContainerView.isHidden = false
//                    self?.errorlabel.isHidden = false
                    self?.timeSlider.isEnabled = false
                }
            }
        }
        
    }
    
    // Mark: - Player options, functionalities
    
    func playVideo() {
        playPauseButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)
        isPlaying = true
        player?.play()
    }
    
    func pauseVideo() {
        playPauseButton.setBackgroundImage(UIImage(named: "play_video"), for: .normal)
        isPlaying = false
        player?.pause()
        controlContainerView.isHidden = false
    }
    
    func dismissVideo() {
        isPlaying = false
        player?.pause()
        player = nil
        
    }
    
    private func muteVideo() {
        let icon = isMuted ? UIImage(named: "volume") : UIImage(named: "mute")
        muteButton.setBackgroundImage(icon, for: .normal)
//        isMuted ? volumeSlider.setValue(lastVolumeSliderPosition, animated: true) : volumeSlider.setValue(0, animated: true)
        isMuted = !isMuted
        player?.isMuted = isMuted
    }
    
    private func showBitRates() {
        let alert = UIAlertController(title: "Select Bit Rate", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let autoAction: UIAlertAction = UIAlertAction(title: "Auto", style: .default) { action -> Void in
            self.bitRateButton.setTitle("Auto ", for: .normal)
            self.selectedBitRate = 512.0
            self.changeBitRate()
        }
        let lowAction: UIAlertAction = UIAlertAction(title: "240p", style: .default) { action -> Void in
            self.bitRateButton.setTitle("240p ", for: .normal)
            self.selectedBitRate = 240.0
            self.changeBitRate()
        }
        let mediumAction: UIAlertAction = UIAlertAction(title: "720p", style: .default ) { action -> Void in
            self.bitRateButton.setTitle("720p ", for: .normal)
            self.selectedBitRate = 720.0
            self.changeBitRate()
        }
        let highAction: UIAlertAction = UIAlertAction(title: "1080p", style: .default ) { action -> Void in
            self.bitRateButton.setTitle("1080p ", for: .normal)
            self.selectedBitRate = 1080.0
            self.changeBitRate()
        }
        let CancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel ) { action -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(autoAction)
        alert.addAction(lowAction)
        alert.addAction(mediumAction)
        alert.addAction(highAction)
        alert.addAction(CancelAction)
        
        alert.modalPresentationCapturesStatusBarAppearance = true
        Utility.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    private func changeBitRate() {
        let videoURL = videoLink
        videoLink = videoURL
//        if let url = URL(string: videoLink) {
//            let asset = AVAsset(url: url)
//            playerItem = AVPlayerItem(asset: asset)
//            playerItem?.preferredPeakBitRate = selectedBitRate
//            player?.replaceCurrentItem(with: playerItem)
//        }
    }

    func enableRewindButton(isEnable: Bool) {
        rewindButton.isEnabled = isEnable
        rewindButton.alpha = isEnable ? 1.0 : 0.7
    }
    
    func enableForwardButton(isEnable: Bool) {
        forwardButton.isEnabled = isEnable
        forwardButton.alpha = isEnable ? 1.0 : 0.7
    }
    
    private func rewindVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    private func forwardVideo(by seconds: Float64) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @objc private func playerEndedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {[weak self] in
            self!.player?.seek(to: CMTime.zero)
            self!.playPauseButton.setBackgroundImage(UIImage(named: "play_video"), for: .normal)
            self!.isPlaying = false
            self!.handleTap()
        }
    }
    
    
    // Mark: - Action event handlers
    
    @objc private func handleTap() {
        self.isControlContainerViewShowing = !self.isControlContainerViewShowing
        UIView.transition(with: self.controlContainerView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.controlContainerView.isHidden = self.isControlContainerViewShowing
        })
    }
    
    @IBAction private func handlePress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            isPlaying ? pauseVideo() : playVideo(); break;
        case 1:
            //forwardVideo(by: 3.0); break;
            didTapForwardButton?()
        case 2:
            //rewindVideo(by: 3.0); break;
            didTapRewindButton?()
        case 3:
            didTapInfoButton?()
            break;
        case 4:
            didVideoInFullScreen?()
            playerController = nil
            playerController = AVPlayerViewController()
            playerController.player = player
            pauseVideo()
            playerController.modalPresentationCapturesStatusBarAppearance = true
            ownerViewController?.present(playerController, animated: true) { [weak self] in
                DispatchQueue.main.async {
                    self?.playerController.player?.play()
                }
            }
        case 5:
            muteVideo(); break;
        case 6:
            showBitRates(); break;
        default: break;
        }
    }
    
    @IBAction func handleSliding(_ slider: UISlider) {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = totalSeconds * Float64(slider.value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime)
        }
    }
    
    
    // Mark: - Deinitialize dependencies & items
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.removeObserver(self, forKeyPath: KeyPath.TimeControl.rawValue)
        player?.removeObserver(self, forKeyPath: KeyPath.LoadedTimeRange.rawValue)
        playerItem?.removeObserver(self, forKeyPath: KeyPath.Status.rawValue)
    }
    
}
