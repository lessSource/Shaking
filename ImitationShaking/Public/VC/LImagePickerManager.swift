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
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            requestAuthorizationWithCompletion(nil)
        }
        return status == .authorized
    }
    
    func requestAuthorizationWithCompletion(_ completion: ((PHAuthorizationStatus) -> ())?) {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if let closure = completion {
                    closure(status)
                }
            }
        }
    }
    
    // 获取相册中资源
    func getPhotoAlbumMedia(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping ([PHAsset]) -> ()) {
        getPhotoAlbumResources(mediaType) { (assetsFetchResult) in
            var asset = [PHAsset]()
            assetsFetchResult.enumerateObjects({ (mediaAsset, index, stop) in
                if mediaAsset.mediaType != .audio {
                    asset.append(mediaAsset)
                }
            })
            successPHAsset(asset)
        }
    }
    
    
    // 获取相册中资源
    private func getPhotoAlbumResources(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping (PHFetchResult<PHAsset>) -> ()) {
        DispatchQueue.global().async {
            self.getAllAlbum()
            var mediaTypePHAsset: PHFetchResult<PHAsset> = PHFetchResult()
            
            // 获取所有资源
            let allPhotosOptions = PHFetchOptions()
            // 按照创建时间倒叙
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
    
    private func getAllAlbum() {
        let options = PHFetchOptions()
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: options)
        for i in 0..<smartAlbums.count {
            let collection: PHCollection = smartAlbums[i];
            if collection is PHAssetCollection {
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil)
                if fetchResult.count > 0 {
                    print(collection.localizedTitle ?? "", fetchResult.count)
                }
            }
        }
        
        let user = PHCollectionList.fetchTopLevelUserCollections(with: options)        
        for i in 0..<user.count {
            let collection: PHCollection = user[i];
            if collection is PHAssetCollection {
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: nil)
                if fetchResult.count > 0 {
                    print(collection.localizedTitle ?? "", fetchResult.count )
                }
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
    
    
}
