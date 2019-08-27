//
//  LAlbumPickerModel.swift
//  ImitationShaking
//
//  Created by less on 2019/8/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

struct LAlbumPickerModel {
    /** 标题 */
    var title: String = ""
    /** 第一图片 */
    var asset: PHAsset?
    /** 图片资源 */
    var fetchResult: PHFetchResult<PHAsset>?
    /** 数量 */
    var count: Int = 0
    
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
