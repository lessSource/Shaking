//
//  LImagePickerManager.swift
//  ImitationShaking
//
//  Created by less on 2019/8/22.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

final class LImagePickerManager  {
    
    static let shared = LImagePickerManager()
    
    private init() { }
}


extension LImagePickerManager {
    // 获取相册权限
    func reuquetsPhotosAuthorization() -> Bool {
        var status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            let semaphore = DispatchSemaphore(value: 0)
            self.requestAuthorizationWithCompletion { (authorizationStatus) in
                status = authorizationStatus
                semaphore.signal()
            }
            semaphore.wait()
            return status == .authorized
        }else {
            return status == .authorized
        }
    }
    
    func requestAuthorizationWithCompletion(_ completion: ((PHAuthorizationStatus) -> ())?) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if let closure = completion {
                closure(status)
            }
        }
    }
}


extension LImagePickerManager {
    // 获取相册
    public func getAlbumResources(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, complete: @escaping (_ dataArray: [LAlbumPickerModel]) -> ()) {
        DispatchQueue.global().async {
            var array: Array = [LAlbumPickerModel]()
            let options = PHFetchOptions()
            
            let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
            for i in 0..<smartAlbums.count {
                let allPhotosOptions = PHFetchOptions()
                if mediaType != .unknown {
                    allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
                }
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: smartAlbums[i], options: allPhotosOptions)
                if smartAlbums[i].assetCollectionSubtype == .smartAlbumAllHidden { continue }
                if smartAlbums[i].assetCollectionSubtype.rawValue == 1000000201 { continue } // [最近删除] 相册
                if fetchResult.count > 0 {
                    let model = LAlbumPickerModel(title: smartAlbums[i].localizedTitle ?? "", asset: fetchResult.lastObject, fetchResult: fetchResult, count: fetchResult.count, selectCount: 0)
                    if smartAlbums[i].assetCollectionSubtype == .smartAlbumUserLibrary {
                        array.insert(model, at: 0)
                    }else {
                        array.append(model)
                    }
                }
            }
            let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: options)
            for i in 0..<userAlbums.count {
                if let collection = userAlbums[i] as? PHAssetCollection {
                    let allPhotosOptions = PHFetchOptions()
                    if mediaType != .unknown {
                        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
                    }
                    let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: allPhotosOptions)
                    if fetchResult.count > 0 {
                        let model = LAlbumPickerModel(title: collection.localizedTitle ?? "", asset: fetchResult.lastObject,fetchResult: fetchResult, count: fetchResult.count, selectCount: 0)
                        array.append(model)
                    }
                }
            }
            DispatchQueue.main.async {
                complete(array)
            }
        }
    }
    
    
    
    // 获取相册中资源
    func getPhotoAlbumMedia(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, fetchResult: PHFetchResult<PHAsset>?, successPHAsset: @escaping ([LMediaResourcesModel]) -> () ) {
        var asset = [LMediaResourcesModel]()
        if let result = fetchResult {
            result.enumerateObjects({ (mediaAsset, index, stop) in
                let time = mediaAsset.mediaType == .video ? self.getNewTimeFromDurationSecond(duration: Int(mediaAsset.duration)) : ""
                let model = LMediaResourcesModel(dataProtocol: mediaAsset, dateEnum: self.getAssetType(asset: mediaAsset), videoTime: time)
                asset.append(model)
            })
            successPHAsset(asset)
        }else {
            getPhotoAlbumResources(mediaType) { (assetsFetchResult) in
                assetsFetchResult.enumerateObjects({ (mediaAsset, index, stop) in
                    let time = mediaAsset.mediaType == .video ? self.getNewTimeFromDurationSecond(duration: Int(mediaAsset.duration)) : ""
                    let model = LMediaResourcesModel(dataProtocol: mediaAsset, dateEnum: self.getAssetType(asset: mediaAsset), videoTime: time)
                    asset.append(model)
                })
                successPHAsset(asset)
            }
        }
    }
    
    // 获取相册中资源
    private func getPhotoAlbumResources(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping (PHFetchResult<PHAsset>) -> ()) {
        DispatchQueue.global().async {
            var mediaTypePHAsset: PHFetchResult<PHAsset> = PHFetchResult()
            // 获取所有资源
            let allPhotosOptions = PHFetchOptions()
            // 获取所需资源
            if mediaType == .unknown {
                mediaTypePHAsset = PHAsset.fetchAssets(with: allPhotosOptions)
            }else {
                allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", mediaType.rawValue)
                
                mediaTypePHAsset = PHAsset.fetchAssets(with: mediaType, options: allPhotosOptions)
            }
            DispatchQueue.main.async {
                successPHAsset(mediaTypePHAsset)
            }
        }
    }
}


extension LImagePickerManager {
    // 获取图片
    @discardableResult
    func getPhotoWithAsset(_ asset: PHAsset, photoWidth: CGFloat, completion: @escaping (UIImage, [AnyHashable: Any]?) -> ()) -> PHImageRequestID {
        var imageSize: CGSize = .zero
        let aspectRatio: CGFloat = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        var pixelWith = photoWidth * Constant.sizeScale
        if aspectRatio > 1.8 {
            pixelWith = pixelWith * aspectRatio
        }
        if aspectRatio < 0.2 {
            pixelWith = pixelWith * 0.5
        }
        let piexlHeight = pixelWith / aspectRatio
        imageSize = CGSize(width: pixelWith, height: piexlHeight)
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        let imageRequestId = PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: option) { (result, info) in
            if let image = result {
                completion(image, info)
            }
        }
        return imageRequestId
    }
    
    // 获取原图
    @discardableResult
    func getOriginalPhotoWithAsset(_ asset: PHAsset, progressHandler: PHAssetImageProgressHandler?, completion: @escaping (UIImage, [AnyHashable: Any]?) -> ()) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.progressHandler = progressHandler
        option.resizeMode = .fast
        option.isSynchronous = true
        //        let imageRequestId = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option) { (result, info) in
        //            let downloadFinined = !(info?[PHImageCancelledKey] as? Bool == true) && info?[PHImageErrorKey] != nil
        //            if result != nil && downloadFinined && info != nil {
        //                completion(result!, info)
        //            }
        //        }
        
        let imageRequestId = PHImageManager.default().requestImageData(for: asset, options: option) { (data, str, orientation, info) in
            if let imageData = data, let image = UIImage(data: imageData) {
                completion(image, info)
            }
        }
        return imageRequestId
    }
        
    // 取消获取图片
    func cancelGetPhoto(_ imageRequestId: PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(imageRequestId)
    }
    
    // 获取选择的图片
    func getSelectPhotoWithAsset(_ dataArray: [LMediaResourcesModel], photoWidth: CGFloat = 80, isOriginal: Bool = true, completion: @escaping ([UIImage], [PHAsset]) -> ()) {
        MBAlertUtil.alertManager.showLoadingMessage()
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.getPhoto.queue")
        var imageArr = [UIImage]()
        var assetArr = [PHAsset]()
        for mediaModel in dataArray {
            queue.async(group: group, execute: DispatchWorkItem(block: {
                guard let asset = mediaModel.dataProtocol as? PHAsset else { return }
                if isOriginal {
                    print(Thread.current)
                    self.getOriginalPhotoWithAsset(asset, progressHandler: nil) { (image, info) in
                        imageArr.append(image)
                        assetArr.append(asset)
                    }
                }else {
                    self.getPhotoWithAsset(asset, photoWidth: photoWidth) { (image, info) in
                        imageArr.append(image)
                        assetArr.append(asset)
                    }
                }
            }))
        }
        
        group.notify(queue: DispatchQueue.main) {
            MBAlertUtil.alertManager.hiddenLoading()
            completion(imageArr, assetArr)
        }
    }
}


extension LImagePickerManager {
    // 获取资源类型
    fileprivate func getAssetType(asset: PHAsset) -> ImageDataEnum {
        if asset.mediaType == .video { return .video }
        if asset.mediaType == .audio { return .audio }
        if asset.mediaType == .image {
            if asset.mediaSubtypes == .photoLive { return .livePhoto }
            if let filename = asset.value(forKey: "filename") as? String, filename.hasSuffix("GIF") {
                return .gif
            }
        }
        return .image
    }

    // 格式化视频时间
    fileprivate func getNewTimeFromDurationSecond(duration: Int) -> String {
        var newTime = ""
        switch duration {
        case 0..<10:
            newTime = "0:0\(duration)"
        case 10..<60:
            newTime = "0:\(duration)"
        default:
            let min = duration / 60
            let sec = duration - (min * 60)
            if (sec < 10) {
                newTime = "\(min):0\(sec)"
            }else {
                newTime = "\(min):\(sec)"
            }
        }
        return newTime
    }
    
}
