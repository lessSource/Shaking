//
//  ShowVideoPlayViewController.swift
//  ImitationShaking
//
//  Created by less on 2019/8/28.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ShowVideoPlayViewController: UIViewController, VideoTabBarViewDelegate {

    public var currentImage: UIImage?
    
    public var videoModel: LMediaResourcesModel?
    
    fileprivate var avAsset: AVAsset?
    
    fileprivate var player: AVPlayer?
    
    fileprivate var playerItem: AVPlayerItem?
    
    fileprivate var plyerLayer: AVPlayerLayer?
    
    fileprivate var timeObserver: Any?
    
    fileprivate var isProgress: Bool = false {
        didSet {
            if !isProgress {
                hiddenProgress()
            }
            self.cancleButton.isHidden = !isProgress
        }
    }
    
    fileprivate lazy var videoView: VideoPlayer = {
        let videoView = VideoPlayer(frame: self.view.bounds)
        videoView.backgroundColor = UIColor.black
        return videoView
    }()
    
    fileprivate lazy var coverImageView: UIImageView = {
        let image = UIImageView(frame: self.view.bounds)
        image.backgroundColor = UIColor.black
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    fileprivate lazy var cancleButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 5, y: Constant.statusHeight + 2, width: 40, height: 40))
        button.setImage(R.image.icon_close(), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    fileprivate lazy var playerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Constant.screenWidth/2 - 25, y: Constant.screenHeight/2 - 25, width: 80, height: 80))
        button.setImage(R.image.icon_video(), for: .normal)
        button.isHidden = true
        return button
    }()
    
    fileprivate lazy var tabBarView: VideoTabBarView = {
        let barView: VideoTabBarView = VideoTabBarView(frame: CGRect(x: 0, y: Constant.screenHeight - Constant.bottomBarHeight, width: Constant.screenWidth, height: Constant.bottomBarHeight))
        barView.delegate = self
        return barView
    }()
    
    deinit {
        print("++++++++释放", self)
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        player = nil
        NotificationCenter.default.removeObserver(self)
        removeObserver()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
        view.addSubview(coverImageView)
        view.addSubview(cancleButton)
        view.addSubview(playerButton)
        view.addSubview(tabBarView)
        coverImageView.image = currentImage
        tabBarView.endLabel.text = changeTimeFormat(timeInterval: Double(videoModel?.videoTime ?? "0") ?? 0)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        playerButton.addTarget(self, action: #selector(playerButtonClick), for: .touchUpInside)
        requestAVAsset()
        addNotification()
        self.isProgress = true
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureClick))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    fileprivate func addObserver() {
        playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil) // 播放状态
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil) // 缓存区间，可用来获取缓存了多少
        playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil) // 缓存不够了 自动暂停播放
        playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil) // 缓存好了 手动播放
    }
    
    fileprivate func removeObserver() {
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
    fileprivate func requestAVAsset() {
        guard let videoResoure = videoModel else { return }
        guard let phAsset = videoResoure.dataProtocol as? PHAsset else { return }
        
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { (asset, audio, dic) in
            DispatchQueue.main.async {
                self.avAsset = asset
                self.videoPlay()
            }
        }
    }
    
    fileprivate func videoPlay() {
        guard let avAsset = self.avAsset else { return }
        playerItem = AVPlayerItem(asset: avAsset)
        addObserver()
        player = AVPlayer(playerItem: playerItem)
        if let playerLayer = videoView.layer as? AVPlayerLayer {
            playerLayer.player = player
        }
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
            // 当前正在播放时间
            let loadTime = CMTimeGetSeconds(time)
            // 视频总时间
            var totalTime: Float64 = 0
            if let duration = self?.player?.currentItem?.duration {
                totalTime = CMTimeGetSeconds(duration)
            }
            self?.tabBarView.progress(proportion: Float(loadTime/totalTime))
            self?.tabBarView.startLabel.text = self?.changeTimeFormat(timeInterval: loadTime)
            self?.tabBarView.endLabel.text = self?.changeTimeFormat(timeInterval: totalTime)
        })
    }
    
    fileprivate func hiddenProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isProgress = false
        }
    }
    
    // MARK:- Event
    @objc fileprivate func playToEndTime() {
        print("end")
        coverImageView.isHidden = false
        playerButton.isHidden = false
        tabBarView.startLabel.text = "00:00:00"
    }
    
    @objc fileprivate func becomeActive() {
        print("进入前台")
        playerButton.isHidden = true
        player?.play()
    }
    
    @objc fileprivate func becomeDeath() {
        print("进入后台")
        playerButton.isHidden = false
        player?.pause()
    }
    
    @objc fileprivate func tapGestureClick() {
        isProgress = !isProgress
    }
    
    @objc fileprivate func playerButtonClick() {
        seekProgress(progress: 0.0)
    }
    
    @objc fileprivate func cancleButtonClick() {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK:- 操作
    // 静音
    fileprivate func muted() {
        player?.isMuted = false
    }
    
    // 音量
    fileprivate func volume() {
        player?.volume = 0.5
    }
    
    // 播放进度
    fileprivate func seekProgress(progress: CGFloat) {
        if let totalTime = player?.currentItem?.duration {
            let totalSec = CMTimeGetSeconds(totalTime)
            let playTimeSec = totalSec * Float64(progress)
            let currentTime = CMTimeMake(value: Int64(playTimeSec), timescale: 1)
            player?.seek(to: currentTime) { (finished) in
                if finished {
                    self.playerButton.isHidden = true
                    self.coverImageView.isHidden = true
                    self.player?.play()
                }
            }
        }
    }
    
    // MARK:- VideoTabBarViewDelegate
    func videoTabBarView(_ view: VideoTabBarView, changeValue: Float) {
        seekProgress(progress: CGFloat(changeValue))
    }
    
    // MARK:- observeValue
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch playerItem?.status {
            case .readyToPlay?:
                print("准备播放")
                player?.play()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   self.coverImageView.isHidden = true
                }
            case .failed?:
                print("播放失败")
            case .unknown?:
                print("unknown")
            case .none:
                print("no")
            @unknown default: break
                
            }
        }else if keyPath == "loadedTimeRanges" {
            let loadTimeArray = playerItem?.loadedTimeRanges
            // 获取最新缓存的区间
            let newTimeRange: CMTimeRange = loadTimeArray?.first as! CMTimeRange
            let startSeconds = CMTimeGetSeconds(newTimeRange.start)
            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration)
            let totalBuffer = startSeconds + durationSeconds // 缓存总长度
            print("当前缓冲时间：\(totalBuffer)")
        }else if keyPath == "playbackBufferEmpty" {
            print("正在缓存视频")
        }else if keyPath == "playbackLikelyToKeepUp" {
            print("缓存好了继续播放")
            player?.play()
        }
    }
    
    // 转时间格式化
    fileprivate func changeTimeFormat(timeInterval: TimeInterval) -> String {
        if timeInterval.isNaN { return "00:00:00" }
        return String(format: "%02d:%02d:%02d", Int(timeInterval) / 3600, (Int(timeInterval) % 3600) / 60, Int(timeInterval) % 60)
    }
}

class VideoPlayer: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
}

// MARK:- AVplayer 通知
// 音频中断通知
// AVAudioSessionInterruptionNotification
// 音频线路改变（耳机插入、拔出）
// AVAudioSessionSilenceSecondaryAudioHintNotification
// 媒体服务器终止、重启
// AVAudioSessionMediaServicesWereLostNotification
// AVAudioSessionMediaServicesWereResetNotification
// 其他app的音频开始播放或者停止时
// AVAudioSessionSilenceSecondaryAudioHintNotification

// 播放结束
// AVPlayerItemDidPlayToEndTime
// 进行跳转
// AVPlayerItemTimeJumpedNotification
// 异常中断通知
// AVPlayerItemPlaybackStalledNotification
// 播放失败
// AVPlayerItemFailedToPlayToEndTimeNotification

protocol VideoTabBarViewDelegate: NSObjectProtocol {
    func videoTabBarView(_ view: VideoTabBarView, changeValue: Float)
}


class VideoTabBarView: UIView {
    
    public weak var delegate: VideoTabBarViewDelegate?
    
    public lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.frame = CGRect(x: 5, y: 0, width: label.intrinsicContentSize.width, height: 49)
        return label
    }()
    
    public lazy var endLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00:00"
        label.textColor = UIColor.white
        label.frame = CGRect(x: Constant.screenWidth - 5 - label.intrinsicContentSize.width , y: 0, width: label.intrinsicContentSize.width, height: 49)
        return label
    }()
    
    
    fileprivate lazy var progressView: UISlider = {
        let sliderView = UISlider(frame: CGRect(x: self.startLabel.frame.maxX + 5, y: self.startLabel.height/2 - 10, width: Constant.screenWidth - self.startLabel.width * 2 - 20, height: 20))
        sliderView.tintColor = UIColor.white
        sliderView.isContinuous = true
        sliderView.setThumbImage(R.image.icon_slider(), for: .normal)
        return sliderView
    }()
    
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.15)
        gradientLayer.colors = [UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor, UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0).cgColor]
        gradientLayer.locations = [0, 1.0]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
        addSubview(startLabel)
        addSubview(endLabel)
        addSubview(progressView)
        progressView.addTarget(self, action: #selector(progressViewClick(_ :)), for: .valueChanged)
    }
    
    public func progress(proportion: Float) {
        if proportion.isNaN { return }
        self.progressView.setValue(proportion, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Event
    @objc fileprivate func progressViewClick(_ sender: UISlider) {
        delegate?.videoTabBarView(self, changeValue: sender.value)
    }
}

