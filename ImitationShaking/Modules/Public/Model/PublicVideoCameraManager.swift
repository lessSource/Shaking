//
//  PublicVideoCameraManager.swift
//  ImitationShaking
//
//  Created by less on 2019/6/14.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import AVFoundation


protocol PublicVideoCameraDelegate: NSObjectProtocol {
    /** 当AVCaptureDevice实例检测到视频主题区域有实质性变化时 */
    func publicVideoCaptureDeviceDidChange()
    
    /** 视频录制结束 */
    func publicVideoDidFinishRecording(_ success: Bool, filePathUrl: URL, currentDuration: TimeInterval, totalDuration: TimeInterval, isOverDuration: Bool)
    
    /** 视频开始录制 */
    func publicVideoDidStartRecording(filePath: String)
    
    /** 视频录制中 */
    func publicVideoDidRecording(filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval)

}

extension PublicVideoCameraDelegate {
    func publicVideoCaptureDeviceDidChange() { }
    func publicVideoDidFinishRecording(_ success: Bool, filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval, isOverDuration: Bool) { }
    func publicVideoDidStartRecording(filePath: String) { }
    func publicVideoDidRecording(filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval) { }
}

class PublicVideoCameraView: UIView {
    
    fileprivate let COUNT_DUR_TIMER_INTERVAL: TimeInterval = 0.05

    
    public weak var delegate: PublicVideoCameraDelegate?
    
    public var captureSession = AVCaptureSession()
    
    /**
     分辨率 默认：AVCaptureSessionPreset1280x720
     需要在setUpSession调用前设置
     */
    public var sessionPreset = AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")
    
    /**
     预览层方向 默认：portrait
     需要在setUpSession调用前设置
     */
    public var captureVideoPreviewOrientation = AVCaptureVideoOrientation.portrait
    
    /** 视频设备 */
    public var captureDevice: AVCaptureDevice?
    public var captureDeviceInput: AVCaptureDeviceInput?
    
    /** 音频设备 */
    public var audioDevice: AVCaptureDevice?
    public var audioDeviceInput: AVCaptureDeviceInput?
    
    /** 视频输出流 */
    public var captureMovieFileOutput = AVCaptureMovieFileOutput()

    /** 预览层 */
    public var previewLayer: AVCaptureVideoPreviewLayer?

    /** 视频地址 */
    fileprivate(set) var videoFilePath: String = ""
    
    /** 视频总时间 */
    fileprivate(set) var totleDuration: TimeInterval = 0
    /** 最小时长 */
    public var minDuration: TimeInterval = 1
    /** 最大时长 */
    public var maxDuration: TimeInterval = Double.leastNormalMagnitude
    /** 是否正在录制 */
    fileprivate(set) var isRecording: Bool = false
    
    
    fileprivate var waitingForStop: Bool?
    fileprivate var currentDuration: TimeInterval = 0
    fileprivate var currentDurationArr: Array = [TimeInterval]()

    fileprivate var cuontDurTime: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("PublicVideoCameraView + 释放")
    }
    
    // MARK: - public
    public func setUpSession() {
        // 设置分辨率
        if captureSession.canSetSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }
        
        // 视频
        captureDevice = AVCaptureDevice.default(for: .video)

        guard let videoDevice = captureDevice else {
            print("获取视频设备失败")
            return
        }
        
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch {
            print(error.localizedDescription)
        }

        if captureSession.canAddInput(captureDeviceInput!) {
            captureSession.addInput(captureDeviceInput!)
        }

        // 音频
        captureDevice = AVCaptureDevice.default(for: .audio)
        guard let audioDevice = captureDevice else {
            print("获音频设备失败")
            return
        }

        do {
            audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
        } catch {
            print(error.localizedDescription)
        }

        if captureSession.canAddInput(audioDeviceInput!) {
            captureSession.addInput(audioDeviceInput!)
        }

        // 不设置这个属性，超过10s的视频会没有声音
        captureMovieFileOutput.movieFragmentInterval = .invalid
        if captureSession.canAddOutput(captureMovieFileOutput) {
            captureSession.addOutput(captureMovieFileOutput)

            let captureConnection = captureMovieFileOutput.connection(with: .video)
            // 开启视频防抖
            if captureConnection?.isVideoStabilizationSupported == true {
                captureConnection?.preferredVideoStabilizationMode = .auto
            }
        }
        
        // 预览层
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = bounds
        layer.insertSublayer(previewLayer!, at: 0)

        // 设置预览层方向
        let captureCpnnection = previewLayer?.connection
        captureCpnnection?.videoOrientation = captureVideoPreviewOrientation
        // 填充模式
        previewLayer?.videoGravity = .resizeAspectFill
        addNotification(to: captureDevice!)
    }
    
    /** 开始录制 */
    public func startRecordVideo(filePath: String) {
        if totleDuration >= maxDuration {
            return
        }
        isRecording = true
        let captureConnection = captureMovieFileOutput.connection(with: .video)
        // 如果正在录制，则重新录制，先暂停
        if captureMovieFileOutput.isRecording {
            stopVideoRecoding()
        }
        // 预览图层 和 视频方向保持一致
        captureConnection?.videoOrientation = previewLayer?.connection?.videoOrientation ?? AVCaptureVideoOrientation.portrait
        // 添加路径
        let fileUrl = URL(fileURLWithPath: filePath)
        videoFilePath = filePath
        captureMovieFileOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    // 结束录制
    public func stopVideoRecoding() {
        waitingForStop = true
        if captureMovieFileOutput.isRecording {
            captureMovieFileOutput.stopRecording()
            videoFilePath = ""
        }
        isRecording = false
        stopCountDurTimer()
    }
    
    /** 移除视频 */
    public func removelastVideo() {
        
    }
    
    // MARK: - notification
    fileprivate func addNotification(to captureDevice: AVCaptureDevice) {
        // 注意 添加区域改变捕获通知必须设置设备允许捕获
        changeDevice(captureDevice: captureDevice) { (device) in
            device.isSubjectAreaChangeMonitoringEnabled = true
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            // 当AVCaptureDevice实例检测到视频主题区域有实质性变化时。
            self?.delegate?.publicVideoCaptureDeviceDidChange()
        }
    }
    
    // MARK: - fileprivate
    // 改变设备属性的统一操作方法
    fileprivate func changeDevice(captureDevice: AVCaptureDevice, property: ((_ device: AVCaptureDevice) -> ())) {
        // 注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
        do {
            try captureDevice.lockForConfiguration()
        } catch  {
            print(error.localizedDescription)
        }
        property(captureDevice)
        captureDevice.unlockForConfiguration()
    }
    
    fileprivate func startCountDurTimer() {
        cuontDurTime = Timer(timeInterval: COUNT_DUR_TIMER_INTERVAL, repeats: true, block: { [weak self] (timer) in
            self?.timeTask(time: timer)
        })
        RunLoop.current.add(cuontDurTime!, forMode: .common)
    }
    
    fileprivate func timeTask(time: Timer) {
        delegate?.publicVideoDidRecording(filePath: videoFilePath, currentDuration: currentDuration, totalDuration: totleDuration)
        // 当录制时间超过最长时间
        if totleDuration >= maxDuration {
            stopVideoRecoding()
        }else {
            currentDuration += COUNT_DUR_TIMER_INTERVAL
            totleDuration += COUNT_DUR_TIMER_INTERVAL
        }
    }
    
    fileprivate func stopCountDurTimer() {
        if self.cuontDurTime != nil {
            self.cuontDurTime?.invalidate()
            self.cuontDurTime = nil
        }
    }
}


extension PublicVideoCameraView: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        if waitingForStop == true {
            stopVideoRecoding()
            return
        }
        currentDuration = 0
        startCountDurTimer()
        delegate?.publicVideoDidStartRecording(filePath: videoFilePath)
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        waitingForStop = false
        if error == nil {
            let isOverDuration = totleDuration >= maxDuration
            currentDurationArr.append(currentDuration)
            delegate?.publicVideoDidFinishRecording(true, filePathUrl: outputFileURL, currentDuration: currentDuration, totalDuration: totleDuration, isOverDuration: isOverDuration)
            print("结束录制")
        }else {
            totleDuration -= currentDuration
            PublicCameraStruct.deleteVideoFile(filePathArr: [videoFilePath])
            delegate?.publicVideoDidFinishRecording(false, filePathUrl: outputFileURL, currentDuration: currentDuration, totalDuration: totleDuration, isOverDuration: false)
            print("录制失败")
        }
    }
}
