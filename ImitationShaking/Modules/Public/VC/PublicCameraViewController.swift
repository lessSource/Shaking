//
//  PublicCameraViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/13.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos

class PublicCameraViewController: BaseViewController {

    /** 闪光灯是否打开 */
    private(set) var isTorch: Bool = false
    

    fileprivate var device: AVCaptureDevice?

    fileprivate lazy var output: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    
    
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    // 视频输出流
    fileprivate lazy var movieFileOutPut: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    // 预览层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
    // 音频设备
    fileprivate var audioDevice: AVCaptureDevice?
    fileprivate var audioDeviceInput: AVCaptureDeviceInput?
    // 视频设备
    fileprivate var captureDevice: AVCaptureDevice?
    fileprivate var captureDeviceInput: AVCaptureDeviceInput?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 视频存放地址
//        let fileUrl = URL(fileURLWithPath: "index")
//        https://github.com/ginhoor/GinCamera
        
        
        setupCameraSession()
        configurationCameraSession()
    }

    // MARK:- private
    // 创建一个回话session
    fileprivate func setupCameraSession() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            session.sessionPreset = AVCaptureSession.Preset.vga640x480
        }else {
            session.sessionPreset = AVCaptureSession.Preset.photo
        }
        // 设置为高分辨率
        if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")) {
            session.sessionPreset = AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")
        }
        // 获取输入设备，builtInWideAngleCamera是通用相机，AVMediaType.video代表视频媒体，back代表前置摄像头，如果需要后置摄像头修改为front
        let availbleDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        device = availbleDevices.first
    }
    // 配置session
    fileprivate func configurationCameraSession() {
        // 获取摄像设备
        guard let device = AVCaptureDevice.default(for: .video) else {
            return
        }
        session.beginConfiguration()
        do {
            // 将后置摄像头作为session的input 输入流
            let captureDeviceInput = try AVCaptureDeviceInput(device: device)
            session.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        // 设定视频预览层
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // 拉伸充满
        
        // 设定输出流
        // 指定像素格式
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
        // 是否直接丢弃处理旧帧时捕获的新帧，默认为true，如果改为false会大幅提高内存使用
        output.alwaysDiscardsLateVideoFrames = true
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        // beginConfiguration() 和 commitConfiguration() 方法中的修改将在commit时同时提交
        session.commitConfiguration()
        session.startRunning()
        
        // 开新线程进行输出流代理方法调用
        let queue = DispatchQueue(label: "com.ImitationShaking.captureQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        
        let captureConnection = output.connection(with: .video)
        if captureConnection?.isVideoStabilizationSupported == true {
            // 防止图片旋转90度
            captureConnection?.videoOrientation = getCaptureVideoOrientation()
        }
    }
    
    // 旋转方向
    fileprivate func getCaptureVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portrait, .faceUp, .faceDown:
            return .portrait
        case .portraitUpsideDown: // 如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown,则视频方向和拍摄时的方向是相反的。
            return .portrait
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
}


extension PublicCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        DispatchQueue.main.async {
            #if false
//            self.session.stopRunning()
            #else
//            self.session.stopRunning()
            #endif
        }
        
    }
}
