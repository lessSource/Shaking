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
}

