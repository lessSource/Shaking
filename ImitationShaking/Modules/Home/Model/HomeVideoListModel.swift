//
//  HomeVideoListModel.swift
//  ImitationShaking
//
//  Created by less on 2019/6/4.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import HandyJSON

struct HomeVideoListModel: HandyJSON {
    /** 视频ID */
    var id: String = ""
    /** 视频标题 */
    var title: String = ""
    /** 视频访问路径 */
    var visitPath: String = ""
    /** 视频封面 */
    var coverImg: String = ""
    /** 视频时长 */
    var timeLength: String = ""
    /** 视频上传时间 */
    var createTimeStamp: String = ""
    /** 点赞数 */
    var praiseCount: Int = 0
    /** 分享数 */
    var shareCount: Int = 0
    /** 评论数 */
    var commentCount: Int = 0
    /** 插眼数 */
    var markCount: Int = 0
    /** 是否已点赞 1已点赞 0未点赞 */
    var isPraise: Int = 0
    /** 提交用户 */
    var submitUser = PublicUserModel()
}
