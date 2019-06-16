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
    
    fileprivate var takingView: UIView = UIView()
    
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
        takingView.layer.cornerRadius = 40
        takingView.backgroundColor = UIColor.red
        takingView.layer.borderWidth = 5
        takingView.layer.borderColor = UIColor.withHex(hexString: "#E7465E", alpha: 0.5).cgColor
        takingView.isUserInteractionEnabled = true
        takingView.addGestureRecognizer(longTap)
        view.addSubview(takingView)
        takingView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constant.barMargin - 30)
        }
        
        view.addSubview(progressView)
        
        let button = UIButton()
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.top.left.equalTo(100)
        }
    }
    
    // MARK: - Event
    @objc fileprivate func longTapClick(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            videoView.startRecordVideo(filePath: MediaFileStruct.getVideoFileName())
        case .changed: break
        case .ended:
            videoView.stopVideoRecoding()
        default: break
        }
    }
    
    @objc func buttonClick() {
        MediaFileStruct.mergeAndExportVideos(urlArray, outputPath: MediaFileStruct.getVideoFileName()) { (success, url) in
            
            
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
        if currentDuration < 15 {
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
        progressView.progress = CGFloat(currentDuration / 15.0)
    }

}




struct MediaFileStruct {
    static func getVideoFileName(_ str: String = "/dasd") -> String {
        _ = createFolder()
        let name = filePath(name: str)
        return "\(name).mp4"
    }
    
    static func deleteVideoFile(filePath: String) -> Bool {
        if filePath.isEmpty { return false }
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: filePath)
            return true
        } catch  {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    static func saveImage(image: UIImage) -> Dictionary<String, Any> {
        let name = createFilename()
        let flag = writeToFile(image: image, path: filePath(name: name))
        return ["name": name, "success": flag]
    }
    
    static func getImageByName(name: String) -> UIImage? {
        if name.isEmpty { return nil }
        let image = UIImage(contentsOfFile: filePath(name: name))
        return image
    }
    
    static func deleteImageByName(name: String) -> Bool {
        if name.isEmpty { return false }
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: filePath(name: name))
        } catch  {
            print(error.localizedDescription)
            return false
        }
        return true
    }

    static func filePath(name: String = "") -> String {
        var tempPath = ""
        if name.isEmpty {
            tempPath = App.bundelName + "/\(name)"
        }else {
            tempPath = App.bundelName + "/\(String.randomStr(len: 5))"
        }
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let filePath = rootPath + "/\(tempPath)"
        return filePath
        
    }
    
    static func createFolder() -> Bool {
        let manager = FileManager.default
        let flag = manager.fileExists(atPath: filePath(), isDirectory: nil)
        
        if !flag {
            do {
                try manager.createDirectory(atPath: filePath(), withIntermediateDirectories: true, attributes: nil)
            } catch  {
                print(error.localizedDescription)
            }
        }
        return flag
    }

    static func createFilename() -> String {
        return UUID().uuidString + String.randomStr(len: 3)
    }
    
    static fileprivate func writeToFile(image: UIImage, path: String) -> Bool {
        _ = createFolder()
        let data: Data = image.jpegData(compressionQuality: 0.3) ?? Data()
        do {
            try data.write(to: URL(fileURLWithPath: path))
        } catch  {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    /**
     视频合成
     
     - parameter videoPathList: 视频地址
     - parameter outputPath: 输出地址
     - parameter presetName: 分辨率， 默认：AVAssetExportPreset640x480
     - parameter outputFileType: 输出格式，默认：AVFileType.mp4
     - parameter completion: 完成回调
     */
    static func mergeAndExportVideos(_ videoPathList: Array<URL>, outputPath: String, presetName: String = AVAssetExportPreset640x480, outputFileType: AVFileType = AVFileType.mp4, completion: @escaping ((Bool, URL) -> ())) {
        if videoPathList.count < 0 { return }
        
        print("视频开始合成")
        
        let mixComposition: AVMutableComposition = AVMutableComposition()
        
        guard let audioTrank: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return
        }
        
        guard let videoTrank: AVMutableCompositionTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            return
        }
        
        var totalDuration: CMTime = .zero
        
        videoPathList.forEach { (url) in
            let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationAndTimingKey: false])
            
            // 向通道内加入视频
            guard let assetVideoTrack = asset.tracks(withMediaType: .video).first else {
                return
            }
            videoTrank.preferredTransform = assetVideoTrack.preferredTransform
            do {
                try videoTrank.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetVideoTrack, at: totalDuration)
            } catch {
                print("videoTrack insert error \(error.localizedDescription)")
            }

            // 获取AVURLAsset中的音频
            guard let assetAudioTrack = asset.tracks(withMediaType: .audio).first else {
                return
            }
            
            // 向通道内加入音频
            do {
                try audioTrank.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: assetAudioTrack, at: totalDuration)
            } catch {
                print("audioTrack insert error \(error.localizedDescription)")
            }


            
            totalDuration = CMTimeAdd(totalDuration, asset.duration)
        }

        let mergeFileURL = URL(fileURLWithPath: outputPath)
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: presetName)
        exporter?.outputURL = mergeFileURL
        exporter?.outputFileType = outputFileType
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.timeRange = CMTimeRange(start: .zero, duration: totalDuration)
        
        exporter?.exportAsynchronously(completionHandler: {
            // 导出状态为完成
            switch exporter!.status {
            case .unknown:
                print("unknown")
            case .failed:
                print("failed")
            case .waiting:
                print("waiting")
            case .exporting:
                print("exporting")
            case .cancelled:
                print("cancelled")
            case .completed:
                print("视频合成完成")
                completion(true, mergeFileURL)
            @unknown default:
                print("@unknown default")
            }
            
        })
    }
    
}
