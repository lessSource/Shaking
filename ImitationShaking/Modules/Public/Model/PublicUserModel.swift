//
//  PublicUserModel.swift
//  ImitationShaking
//
//  Created by less on 2019/6/4.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import HandyJSON


struct PublicUserModel: HandyJSON {
    /** 用户ID */
    var id: String = ""
    /** 用户头像 */
    var headImg: String = ""
    /** 用户昵称 */
    var nickName: String = ""
    /** 用户性别 */
    var sex: String = ""
    /** 生日 */
    var birthday: String = ""
    /** 地区 */
    var region: String = ""
    /** 介绍 */
    var introduction: String = ""
    /** 抖腿号 */
    var shakelegsName: String = ""
    /** 是否关注 */
    var isFollewed: Int = 0
}

