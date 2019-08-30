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
    
    // 获取相册中资源
    func getPhotoAlbumMedia(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, fetchResult: PHFetchResult<PHAsset>?, successPHAsset: @escaping ([LMediaResourcesModel]) -> () ) {
        var asset = [LMediaResourcesModel]()
        if let result = fetchResult {
            result.enumerateObjects({ (mediaAsset, index, stop) in
                if mediaAsset.mediaType != .audio {
                    let model = LMediaResourcesModel(dataProtocol: mediaAsset, dateEnum: mediaAsset.mediaType == .image ? .image : .video)
                    asset.append(model)
                }else {
                    print("audioaudioaudioaudioaudio")
                }
            })
            successPHAsset(asset)
        }else {
            getPhotoAlbumResources(mediaType) { (assetsFetchResult) in
                assetsFetchResult.enumerateObjects({ (mediaAsset, index, stop) in
                    if mediaAsset.mediaType != .audio {
                        let model = LMediaResourcesModel(dataProtocol: mediaAsset, dateEnum: mediaAsset.mediaType == .image ? .image : .video)
                        asset.append(model)
                    }else {
                        print("audioaudioaudioaudioaudio")
                    }
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
            // 按照创建时间倒叙
//            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
    
    public func getAlbumResources(_ complete: @escaping (_ dataArray: [LAlbumPickerModel]) -> ()) {
        DispatchQueue.global().async {
            var array: Array = [LAlbumPickerModel]()
            let options = PHFetchOptions()
            
            let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
            for i in 0..<smartAlbums.count {
                let allPhotosOptions = PHFetchOptions()
//                allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
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
//                    allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
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
    
//    // 获取图片
//    @discardableResult
//    func getPhotoWithAsset(asset: PHAsset, photoWidth: CGFloat, networkAccessAllowed: Bool, completion: (_ photo: UIImage, _ info: [AnyHashable: Any], _ isDegraded: Bool) -> (), progressHandler: (_ progress: Double, _ error: Error, _ stop: Bool, _ info: [AnyHashable: Any]) -> ()) -> PHImageRequestID {
//        
//        var image: UIImage?
//        let option: PHImageRequestOptions = PHImageRequestOptions()
//        option.resizeMode = .fast
//        let imageRequestID = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: photoWidth, height: photoWidth), contentMode: .aspectFill, options: option) { (result, info) in
//            image = result
//            let downloadFinined = ((info?[PHImageCancelledKey]) != nil) && ((info?[PHImageErrorKey]) != nil)
//            if downloadFinined && (result != nil) {
//                image = result?.fixOrientation()
//                completion(image!, info!, ((info?[PHImageResultIsDegradedKey]) != nil))
//            }
//            
//            if (info![PHImageResultIsInCloudKey] != nil) && result != nil && networkAccessAllowed {
//                let options: PHImageRequestOptions = PHImageRequestOptions()
////                options.progressHandler = { progress, error, stop, info in
////                    DispatchQueue.main.async {
////                        progressHandler(progress, error, stop, info)
////                    }
////                }
//                options.isNetworkAccessAllowed = true
//                options.resizeMode = .fast
//                PHImageManager.default().requestImageData(for: asset, options: options) { (data, dataUTI, orientation, info) in
//                    
//                }
//            }
//        }
//        
//    }
    
    @discardableResult
    func getPhotoWithAsset(_ asset: PHAsset, photoWidth: CGFloat, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> ()) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        let imageRequestId = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: photoWidth, height: photoWidth), contentMode: .aspectFill, options: option) { (image, info) in
            completion(image, info)
        }
        return imageRequestId
    }
    
    
    // 获取
    
}
