//
//  NetConst.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/1.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit



enum HomeRequest: String {
    /** 首页 */
    case homeList = "dasdasde"
    
    /** 首页 */
    case homeDetail = "dasdasdewww"
}


/** 获取评论列表 */
let RquestCommentsList = "api/comment/list/source"

/** 提交评论 */
let RequestCommentsSubmit = "api/comment"

/** 获取评论回复列表 */
let RequestCommentsReplyList = "api/comment/list/origin"

/** 评论点赞 */
let RequestCommentsPraise = "api/comment/praise/"

/** 评论取消点赞 */
let RequestCommentsPraiseCancel = "api/comment/praise_cancel/"
