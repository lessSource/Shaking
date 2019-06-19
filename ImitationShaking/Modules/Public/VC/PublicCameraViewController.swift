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
    
    // 视频
    fileprivate lazy var videoView: PublicVideoCameraView = {
        let videoView = PublicVideoCameraView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
        videoView.delegate = self
        videoView.setUpSession()
        videoView.maxDuration = 15
        return videoView
    }()
    
    // 操作
    fileprivate lazy var operationView: PublicVideoOperationView = {
        let view = PublicVideoOperationView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        return view
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
        view.addSubview(videoView)
        videoView.captureSession.startRunning()
        view.addSubview(operationView)
        
       
        
        
//
//        let deleteButton = UIButton()
//        deleteButton.setImage(R.image.icon_VideoDel(), for: .normal)
//        videoView.addSubview(deleteButton)
////        deleteButton.hitTestEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
//        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
//        deleteButton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(takingView)
//            make.right.equalTo(-30)
//            make.width.equalTo(44)
//            make.height.equalTo(44)
//        }
//
    }
    

    
    
    @objc fileprivate func deleteButtonClick() {
//        if urlArray.count > 1 {
//            videoView.removelastVideo()
//            progressView.removeProgressView()
//            urlArray.remove(at: urlArray.count - 1)
//            print(urlArray)
//        }
//        print("deleteButtonClick")
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
        if success {
//            urlArray.append(filePathUrl)
        }else {
//            progressView.progress = CGFloat(totalDuration / 15.0)
        }
        if totalDuration < 15 && success {
//            progressView.suspensionProportion()
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
//        progressView.progress = CGFloat(totalDuration / 15.0)
    }

}
