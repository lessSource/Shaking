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

class ShowVideoPlayViewController: UIViewController {

    public var currentImage: UIImage?
    
    public var asset: PHAsset?
    
    fileprivate var player: AVPlayer!
    
    fileprivate var playerItem: AVPlayerItem!
    
    fileprivate lazy var videoView: VideoPlayer = {
        let videoView = VideoPlayer(frame: self.view.bounds)
        videoView.backgroundColor = UIColor.black
        return videoView
    }()
    
    fileprivate lazy var coverImageView: UIImageView = {
        let image = UIImageView(frame: self.view.bounds)
        image.backgroundColor = UIColor.black
        return image
    }()
    
    fileprivate var plyerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
        view.addSubview(coverImageView)
        coverImageView.image = currentImage
        requestAVAsset()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.playerItem.removeObserver(self, forKeyPath: "status")
        self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.playerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
    fileprivate func addObserver() {
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil) // 播放状态
        self.playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil) // 缓存区间，可用来获取缓存了多少
        self.playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil) // 缓存不够了 自动暂停播放
        self.playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil) // 缓存好了 手动播放
    }
    
    fileprivate func requestAVAsset() {
        guard let phAsset = asset else { return }
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil) { (asset, audio, dic) in
            DispatchQueue.main.async {
                self.play(asset)
            }
        }
    }
    
    fileprivate func play(_ avAsset: AVAsset?) {
        guard let avAsset = avAsset else { return }
        let playerItem = AVPlayerItem(asset: avAsset)
        self.playerItem = playerItem
        addObserver()
        player = AVPlayer(playerItem: self.playerItem)
        if let playerLayer = videoView.layer as? AVPlayerLayer {
            playerLayer.player = player
        }
        coverImageView.isHidden = true
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self] (time) in
            // 当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            // 视频总时间
            let totalTime = CMTimeGetSeconds(self?.player.currentItem?.duration ?? time)
            print(self?.changeTimeFormat(timeInterval: loadTime) ?? 0,"|||||",  self?.changeTimeFormat(timeInterval: totalTime) ?? 0)
        }
        
    }
    
    @objc fileprivate func playToEndTime() {
        print("end")
        coverImageView.isHidden = false
    }
    
    @objc fileprivate func becomeActive() {
        print("进入前台")
        player.play()
    }
    
    @objc fileprivate func becomeDeath() {
        print("进入后台")
        player.pause()
    }
    
    // 静音
    fileprivate func muted() {
        player.isMuted = false
    }
    
    // 音量
    fileprivate func volume() {
        player.volume = 0.5
    }
    
    // 播放进度
    fileprivate func progress() {
        if let totalTime = player.currentItem?.duration {
            let totalSec = CMTimeGetSeconds(totalTime)
            let playTimeSec = totalSec * 0.5
            let currentTime = CMTimeMake(value: Int64(playTimeSec), timescale: 1)
            player.seek(to: currentTime) { (finished) in
                
            }
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch playerItem.status {
            case .readyToPlay:
                print("准备播放")
                player.play()
            case .failed:
                print("播放失败")
            case .unknown:
                print("unknown")
            @unknown default: break
                
            }
        }else if keyPath == "loadedTimeRanges" {
            let loadTimeArray = playerItem.loadedTimeRanges
            // 获取最新缓存的区间
            let newTimeRange: CMTimeRange = loadTimeArray.first as! CMTimeRange
            let startSeconds = CMTimeGetSeconds(newTimeRange.start)
            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration)
            let totalBuffer = startSeconds + durationSeconds // 缓存总长度
            print("当前缓冲时间：\(totalBuffer)")
        }else if keyPath == "playbackBufferEmpty" {
            print("正在缓存视频")
        }else if keyPath == "playbackLikelyToKeepUp" {
            print("缓存好了继续播放")
            player.play()
        }
    }
    
    // 转时间格式化
    fileprivate func changeTimeFormat(timeInterval: TimeInterval) -> String {
        if timeInterval.isNaN { return "00:00:00" }
        return String(format: "%02d:%02d:%02d", (Int(timeInterval) % 3600) / 60, Int(timeInterval) / 3600, Int(timeInterval) % 60)
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
