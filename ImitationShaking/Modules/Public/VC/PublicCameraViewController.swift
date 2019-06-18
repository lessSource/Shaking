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
    
    fileprivate lazy var operationView: PublicVideoOperationView = {
        let view = PublicVideoOperationView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        return view
    }()
    
    // 摄像按钮
    fileprivate lazy var takingView: UIView = {
        let view = UIView(frame: CGRect(x: Constant.screenWidth/2 - 35, y: Constant.screenHeight - 120, width: 70, height: 70))
        view.layer.cornerRadius = 35
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.withHex(hexString: "#E7445A")
        return view
    }()
    
    // 圆环
    fileprivate lazy var ringView: TakingRingView = {
        let view = TakingRingView(frame: CGRect(x: 0, y: 0, width: 85, height: 85))
        view.center = takingView.center
        return view
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
        
        view.addSubview(operationView)
        
        let longTap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTapClick(_ :)))
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureClick))
        takingView.addGestureRecognizer(longTap)
        takingView.addGestureRecognizer(tapGesture)
        view.addSubview(ringView)
        view.addSubview(takingView)
        view.addSubview(progressView)
        let cancleButton = UIButton(frame: CGRect(x: 15, y: progressView.frame.maxY + 20, width: 25, height: 25))
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.setBackgroundImage(R.image.icon_fork(), for: .normal)
        view.addSubview(cancleButton)
        
        let deleteButton = UIButton()
        deleteButton.setImage(R.image.icon_VideoDel(), for: .normal)
        videoView.addSubview(deleteButton)
//        deleteButton.hitTestEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(takingView)
            make.right.equalTo(-30)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
 
    }
    
    // MARK: - Event
    @objc fileprivate func longTapClick(_ sender: UILongPressGestureRecognizer) {
        print("longTapClick")
        switch sender.state {
        case .began:
            if videoView.totleDuration < 15 {
                videoView.startRecordVideo(filePath: PublicCameraStruct.getVideoFileName())
                takingAnimation(0.5, radius: 5, forKey: "startRecordVideo")
            }
        case .changed: break
        case .ended:
            videoView.stopVideoRecoding()
        default: break
        }
    }
    
    @objc fileprivate func tapGestureClick() {
        if !videoView.isRecording {
            if videoView.totleDuration < 15 {
                videoView.startRecordVideo(filePath: PublicCameraStruct.getVideoFileName())
                takingAnimation(0.5, radius: 5, forKey: "startRecordVideo")
            }
        }else {
            videoView.stopVideoRecoding()
        }
    }
    
    @objc fileprivate func deleteButtonClick() {
        if urlArray.count > 1 {
            videoView.removelastVideo()
            progressView.removeProgressView()
            urlArray.remove(at: urlArray.count - 1)
            print(urlArray)
        }
        print("deleteButtonClick")
    }
    
    // 按钮动画
    fileprivate func takingAnimation(_ scale: CGFloat, radius: CGFloat, forKey: String) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.4
        groupAnimation.repeatCount = 1
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = scale
        let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusAnimation.toValue = radius
        groupAnimation.animations = [scaleAnimation, radiusAnimation]
        
        takingView.layer.add(groupAnimation, forKey: forKey)
    }
    
    // 圆环动画
    fileprivate func ringAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 1.2
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = .forwards
        ringView.layer.add(scaleAnimation, forKey: "ringView")
        
        self.ringView.lineWidth = 20
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
    
    // 取消
    @objc fileprivate func cancleButtonClick() {
        dismiss(animated: true, completion: nil)
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
        takingAnimation(1, radius: 35, forKey: "stopVideoRecoding")
        if success {
            urlArray.append(filePathUrl)
        }else {
            progressView.progress = CGFloat(totalDuration / 15.0)
        }
        if totalDuration < 15 && success {
            progressView.suspensionProportion()
        }else {
            
            
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
