//
//  NetConst.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/1.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

/** 登录注册 */
struct LoginRegisterRequest {
    /** 登录 */
    static let login = "api/auth/login"
    /** 跟新头像 */
    static let headImage = "api/personal/headImg"
}

/** 视频 */
struct VideoRequest {
    /** 列表 */
    static let list = "api/video/list"
    /** 点赞 */
    static let praise = "api/video/praise/"
    /** 取消点赞 */
    static let praiseCancel = "api/video/praise_cancel/"
    /** 上传 */
    static let upload = "api/video/upload"
}

/** 评论 */
struct CommentsRequest {
    /** 列表 */
    static let list = "api/comment/list/source"
    /** 提交评论 */
    static let submit = "api/comment"
    /** 回复列表 */
    static let replyList = "api/comment/list/origin"
    /** 点赞 */
    static let praise = "api/comment/praise/"
    /** 取消点赞 */
    static let praiseCancel = "api/comment/praise_cancel/"
}
