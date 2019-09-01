//
//  LAlbumPickerModel.swift
//  ImitationShaking
//
//  Created by less on 2019/8/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

protocol ImageDataProtocol { }

extension UIImage: ImageDataProtocol { }

extension String: ImageDataProtocol { }

extension PHAsset: ImageDataProtocol { }


enum ImageDataEnum {
    case image
    case video
    case livePhoto
}

struct LAlbumPickerModel {
    /** 标题 */
    var title: String = ""
    /** first PHAsset */
    var asset: PHAsset?
    /** 媒体资源 */
    var fetchResult: PHFetchResult<PHAsset>?
    /** 数量 */
    var count: Int = 0
    /** 选中数量 */
    var selectCount: Int = 0
}

struct LMediaResourcesModel: Equatable {
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

func ==(lhs: LMediaResourcesModel, rhs: LMediaResourcesModel) -> Bool {
    if let lhsStr = lhs.dataProtocol as? String, let rhsStr = rhs.dataProtocol as? String {
        return lhsStr == rhsStr
    }else if let lhsAss = lhs.dataProtocol as? PHAsset, let rhsAss = rhs.dataProtocol as? PHAsset {
        return lhsAss.localIdentifier == rhsAss.localIdentifier
    }else if let lhsImg = lhs.dataProtocol as? UIImage, let rhsImg = rhs.dataProtocol as? UIImage {
        return lhsImg == rhsImg
    }
    return false
}

