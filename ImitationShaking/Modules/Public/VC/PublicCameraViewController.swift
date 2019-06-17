//
//  PublicCameraViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/13.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Moya
import AVFoundation

class PublicCameraViewController: BaseViewController {
    
    fileprivate var videoView: PublicVideoCameraView = PublicVideoCameraView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
    
    // 摄像按钮
    fileprivate lazy var takingView: UIView = {
        let view = UIView(frame: CGRect(x: Constant.screenWidth/2 - 40, y: Constant.screenHeight - 130, width: 80, height: 80))
        view.layer.cornerRadius = 40
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.withHex(hexString: "#E7445A")
        return view
    }()
    
//     圆环
    fileprivate lazy var ringShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
//        shapeLayer.frame = self.takingView.bounds
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: 200, y: 200), radius: 40, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
//        let path = v(arcCenter: CGPoint(x: 200, y: 200), radius: 47, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//        path.lineWidth = 47
        
        shapeLayer.path = path.cgPath
        // 描线的线宽
        shapeLayer.lineWidth = 40
        // 描线起始点
//        shapeLayer.strokeStart = 0
        // 描线终点
//        shapeLayer.strokeEnd = 1
        shapeLayer.miterLimit = 0
        
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 填充色
        shapeLayer.strokeColor = UIColor.withHex(hexString: "#E7445A", alpha: 0.8).cgColor
        return shapeLayer
    }()

    
    fileprivate lazy var progressView: PublicVideoProgressView = {
        let progressView = PublicVideoProgressView(frame: CGRect(x: 5, y: 5, width: Constant.screenWidth - 10, height: 5))
        return progressView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var urlArray: Array<URL> = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
    }
    
    // MARK: - layoutView
    fileprivate func layoutView() {
        videoView.delegate = self
        videoView.setUpSession()
        view.addSubview(videoView)
        videoView.maxDuration = 15
        videoView.captureSession.startRunning()
        
        
        let longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapClick(_ :)))
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureClick))
        takingView.addGestureRecognizer(longTap)
        takingView.addGestureRecognizer(tapGesture)
        view.layer.addSublayer(ringShapeLayer)
        view.addSubview(takingView)

        view.addSubview(progressView)

    }
    
    // MARK: - Event
    @objc fileprivate func longTapClick(_ sender: UILongPressGestureRecognizer) {
        print("longTapClick")
        switch sender.state {
        case .began: 
            videoView.startRecordVideo(filePath: PublicCameraStruct.getVideoFileName())
        case .changed: break
        case .ended:
            videoView.stopVideoRecoding()
        default: break
        }
    }
    
    @objc fileprivate func tapGestureClick() {
//        print("tapGestureClick")
        takingView.isHidden = true
        videoView.startRecordVideo(filePath: PublicCameraStruct.getVideoFileName())

        let animate: CABasicAnimation = CABasicAnimation(keyPath: "lineWidth")
        animate.isRemovedOnCompletion = false
        animate.duration = 1
        animate.fromValue = 7
        animate.toValue = 30
        animate.repeatCount = 20
        animate.autoreverses = true
        ringShapeLayer.add(animate, forKey: "lineWidthKey")
    }
    
    @objc func buttonClick() {
        PublicCameraStruct.mergeAndExportVideos(urlArray, outputPath: PublicCameraStruct.getVideoFileName()) { (success, url) in
            
            
            let videoData =  Moya.MultipartFormData(provider: .file(url), name: "file", fileName: "file", mimeType: "mp4")
            var params: Dictionary<String, Any> = [String: Any]()
            params.updateValue("测试一个合成视频", forKey: "title")
            params.updateValue(15, forKey: "timeLength")
            Network.default.request(CommonTargetTypeApi.uploadMultipart(VideoRequest.upload, [videoData], params), successClosure: { (response) in
                self.dismiss(animated: true, completion: nil)
            }) { (error) in
                print("aaaaa")
            }
        }
    }
}

extension PublicCameraViewController: PublicVideoCameraDelegate {
    /** 当AVCaptureDevice实例检测到视频主题区域有实质性变化时 */
    func publicVideoCaptureDeviceDidChange() {
        print("AVCaptureDevice")
    }
    
    /** 视频录制结束 */
    func publicVideoDidFinishRecording(_ success: Bool, filePathUrl: URL, currentDuration: TimeInterval, totalDuration: TimeInterval, isOverDuration: Bool) {
        print("视频录制结束：\(filePathUrl)" + "当前时间：\(currentDuration), 总时间：\(totalDuration)")
        urlArray.append(filePathUrl)
        print(urlArray)
        if totalDuration < 15 && success {
            progressView.suspensionProportion()
        }else {
            ringShapeLayer.removeAllAnimations()

            
            
//            let videoData =  Moya.MultipartFormData(provider: .file(filePathUrl), name: "file", fileName: "file", mimeType: "mp4")
//            var params: Dictionary<String, Any> = [String: Any]()
//            params.updateValue("测试视频", forKey: "title")
//            params.updateValue(15, forKey: "timeLength")
//            Network.default.request(CommonTargetTypeApi.uploadMultipart(VideoRequest.upload, [videoData], params), successClosure: { (response) in
//                self.dismiss(animated: true, completion: nil)
//            }) { (error) in
//                print("aaaaa")
//            }
        }
    }
    
    /** 视频开始录制 */
    func publicVideoDidStartRecording(filePath: String) {
        print("视频开始录制" + filePath)
    }
    
    /** 视频录制中 */
    func publicVideoDidRecording(filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval) {
        print("视频录制中" + filePath + "当前时间：\(currentDuration), 总时间：\(totalDuration)")
        progressView.progress = CGFloat(totalDuration / 15.0)
    }

}
