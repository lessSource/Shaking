//
//  PublicCameraViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/13.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class PublicCameraViewController: BaseViewController {
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoVC = PublicVideoCameraView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: Constant.screenHeight))
        videoVC.delegate = self
        videoVC.setUpSession()
        view.addSubview(videoVC)
        videoVC.maxDuration = 10
        videoVC.captureSession.startRunning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            videoVC.startRecordVideo(filePath: MediaFileStruct.getVideoFileName())
        }
        
    }
    
//    let data1 =  Moya.MultipartFormData(provider: .file(outputFileURL), name: "file", fileName: "file", mimeType: "mp4")
//    var params: Dictionary<String, Any> = [String: Any]()
//    params.updateValue("dddddddd", forKey: "title")
//    params.updateValue(15, forKey: "timeLength")
//    Network.default.request(CommonTargetTypeApi.uploadMultipart(VideoRequest.upload, [data1], params), successClosure: { (response) in
//    print("ddd")
//    }) { (error) in
//    print("aaaaa")
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

extension PublicCameraViewController: PublicVideoCameraDelegate {
    /** 当AVCaptureDevice实例检测到视频主题区域有实质性变化时 */
    func publicVideoCaptureDeviceDidChange() {
        print("AVCaptureDevice")
    }
    
    /** 视频录制结束 */
    func publicVideoDidFinishRecording(_ success: Bool, filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval, isOverDuration: Bool) {
        print("视频录制结束" + filePath + "当前时间：\(currentDuration), 总时间：\(totalDuration)")
    }
    
    /** 视频开始录制 */
    func publicVideoDidStartRecording(filePath: String) {
        print("视频开始录制" + filePath)
    }
    
    /** 视频录制中 */
    func publicVideoDidRecording(filePath: String, currentDuration: TimeInterval, totalDuration: TimeInterval) {
        print("视频录制中" + filePath + "当前时间：\(currentDuration), 总时间：\(totalDuration)")
    }

}




struct MediaFileStruct {
    static func getVideoFileName() -> String {
        _ = createFolder()
        let name = createFilename()
        return "/\(filePath(name: name)).mp4"
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
            tempPath = App.bundelName
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
        return UUID().uuidString
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
    
}
