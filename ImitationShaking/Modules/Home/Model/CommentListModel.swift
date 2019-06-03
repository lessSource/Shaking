//
//  CommentListModel.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/2.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import HandyJSON

struct CommentListModel: HandyJSON {
    /** 评论id */
    var id: String = ""
    /** 父评论id */
    var parentId: String = ""
    /** 源评论id(直接对资源进行评论的评论) */
    var originId: String = ""
    /** 评论用户id */
    var userId: String = ""
    /** 资源id */
    var sourceId: String = ""
    /** 资源类型1:视频 2:图片 3:文字 */
    var sourceType: Int = 0
    /** 评论类容 */
    var content: String = ""
    /** 评论高度 */
    var contentHeight: CGFloat {
        return content.heightWithStringAttributes(attributes: [.font : UIFont.systemFont(ofSize: 14)], fixedWidth: Constant.screenWidth - 115) + 45
    }
    /** 状态 1、有效 0、删除 */
    var status: Int = -1
    /** 评论时间 */
    var createTime: String = ""
    /** 点赞数量 */
    var praiseCount: Int = 0
    /** 是否点赞 */
    var isPraise: Int = 0
    /** 评论数量 */
    var commentCount: Int = 0
    /** 分享数量 */
    var shareCount: Int = 0
    /** 插眼数量 */
    var markCount: Int = 0
    /** 评论用户 */
    var submitUser = CommentListUserModel()
    /** 父评论用户 */
    var parentUser = CommentListUserModel()
    /** 回复 */
    var childrenList = [CommentListModel]()
    /** 当前回复页数 */
    var childrenPage: Int = 1
}



struct CommentListUserModel: HandyJSON {
    /** 用户ID */
    var id: String = ""
    /** 用户头像 */
    var headImg: String = ""
    /** 用户昵称 */
    var nickName: String = ""
    /** 用户性别 */
    var sex: String = ""
}

