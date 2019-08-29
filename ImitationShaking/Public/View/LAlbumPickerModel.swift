//
//  LAlbumPickerModel.swift
//  ImitationShaking
//
//  Created by less on 2019/8/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

protocol ImageDataProtocol {}

extension UIImage: ImageDataProtocol { }

extension String: ImageDataProtocol { }

extension PHAsset: ImageDataProtocol { }

extension LAssetModel: ImageDataProtocol { }

enum ImageDataEnum {
    case image
    case video
    case livePhoto
}


struct LAlbumPickerModel {
    /** 标题 */
    var title: String = ""
    /** 第一图片 */
    var asset: PHAsset?
    /** 图片资源 */
    var fetchResult: PHFetchResult<PHAsset>?
    /** 数量 */
    var count: Int = 0
    /** 选中数量 */
    var selectCount: Int = 0
}

struct LAssetModel {
    /** 是否选中 */
    var isSelect: Bool
    /** 资源 */
    var asset: PHAsset
    
    init(isSelect: Bool = false, asset: PHAsset) {
        self.isSelect = isSelect
        self.asset = asset
    }
}

struct LMediaResourcesModel {
    /** 资源 */
    var dataProtocol: ImageDataProtocol
    /** 类型 */
    var dateEnum: ImageDataEnum
    /** 是否选中 */
    var isSelect: Bool
    /** 视频时间 */
    var videoTime: String
    
    init(dataProtocol: ImageDataProtocol, dateEnum: ImageDataEnum,isSelect: Bool = false, videoTime: String = "") {
        self.dataProtocol = dataProtocol
        self.dateEnum = dateEnum
        self.isSelect = isSelect
        self.videoTime = videoTime
    }
    
}
