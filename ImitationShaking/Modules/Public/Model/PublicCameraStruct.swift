//
//  PublicCameraStruct.swift
//  ImitationShaking
//
//  Created by less on 2019/6/17.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

struct PublicCameraStruct {
    
    
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
                deleteVideoFile(filePathArr: videoPathList.compactMap { return $0.path })
                print("视频合成完成")
                completion(true, mergeFileURL)
            @unknown default:
                print("@unknown default")
            }
            
        })
    }
    
    // 获取视频地址
    static func getVideoFileName(_ name: String = "") -> String {
        _ = createFolder()
        return filePath() + "\(String.randomStr(len: 10)).mp4"
    }
    
    // 创建文件夹
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
    
    // 获取路径地址
    static func filePath(name: String = "") -> String {
        var tempPath = ""
        if name.isEmpty {
            tempPath = App.bundelName + "/\(name)"
        }else {
            tempPath = App.bundelName
        }
        let filePath = App.documentsPath + "/\(tempPath)"
        return filePath
        
    }
    
    // 删除视频文件
    static func deleteVideoFile(filePathArr: [String]) {
        if filePathArr.isEmpty { return }
        let manager = FileManager.default
        do {
            try filePathArr.forEach { (filePath) in
                try manager.removeItem(atPath: filePath)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    // 获取相册中资源
    static func getPhotoAlbumResources(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping (PHFetchResult<PHAsset>) -> ()) {
        DispatchQueue.global().async {
            
            var mediaTypePHAsset: PHFetchResult<PHAsset> = PHFetchResult()
            
            // 获取所有资源
            let allPhotosOptions = PHFetchOptions()
            // 按照创建时间倒叙
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            // 获取所需资源
            if mediaType == .unknown {
                mediaTypePHAsset = PHAsset.fetchAssets(with: allPhotosOptions)
            }
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
            
            mediaTypePHAsset = PHAsset.fetchAssets(with: mediaType, options: allPhotosOptions)
            
            DispatchQueue.main.async {
                successPHAsset(mediaTypePHAsset)
            }
        }
    }
    
    // 获取相册中第一张图片
    static func getPhotoAlbumAFristImage(_ successImage: @escaping (UIImage?) -> ()) {
        getPhotoAlbumResources(.image) { (assetsFetchResult) in
            
            guard let imagePHAsset = assetsFetchResult.firstObject else {
                successImage(R.image.icon_fork())
                return
            }
            
            let imageManager: PHCachingImageManager = PHCachingImageManager()
            imageManager.requestImage(for: imagePHAsset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: nil) { (image, dic) in
                successImage(image)
            }
        }
    }
    
    // 获取相册中资源
    static func getPhotoAlbumMedia(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping ([PHAsset]) -> ()) {
        getPhotoAlbumResources(mediaType) { (assetsFetchResult) in
            var asset = [PHAsset]()
            assetsFetchResult.enumerateObjects({ (mediaAsset, index, stop) in
                asset.append(mediaAsset)
            })
            successPHAsset(asset)
        }
        
    }
    
    
//    static func getImageByName(name: String) -> UIImage? {
//        if name.isEmpty { return nil }
//        let image = UIImage(contentsOfFile: filePath(name: name))
//        return image
//    }
//
//    static func deleteImageByName(name: String) -> Bool {
//        if name.isEmpty { return false }
//        let manager = FileManager.default
//        do {
//            try manager.removeItem(atPath: filePath(name: name))
//        } catch  {
//            print(error.localizedDescription)
//            return false
//        }
//        return true
//    }
//
//
//    
//
//
//    static fileprivate func writeToFile(image: UIImage, path: String) -> Bool {
//        _ = createFolder()
//        let data: Data = image.jpegData(compressionQuality: 0.3) ?? Data()
//        do {
//            try data.write(to: URL(fileURLWithPath: path))
//        } catch  {
//            print(error.localizedDescription)
//            return false
//        }
//        return true
//    }
    
 
}
