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
                asset.append(mediaAsset)
            })
            successPHAsset(asset)
        }
    }
    
    
    // 获取相册中资源
    private func getPhotoAlbumResources(_ mediaType: PHAssetMediaType = PHAssetMediaType.unknown, successPHAsset: @escaping (PHFetchResult<PHAsset>) -> ()) {
        DispatchQueue.global().async {
            
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
    
    // 获取图片
    @discardableResult
    func getPhotoWithAsset(_ asset: PHAsset, photoWidth: CGFloat, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> ()) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        let imageRequestId = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: photoWidth, height: photoWidth), contentMode: .aspectFill, options: option) { (image, info) in
            
//            let downloadFinined = info?[PHImageCancelledKey]
            
            
            completion(image, info)
        }
        return imageRequestId
    }
    
    
}
