//
//  CommentRequestStruct.swift
//  ImitationShaking
//
//  Created by less on 2019/6/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

struct CommentRequestStruct {
    
    /** 评论点赞 */
    static func requestCommentsPraise(_ commentId: String, success: @escaping (() -> ())) {
        Network.default.request(CommonTargetTypeApi.postRequest(RequestCommentsPraise + commentId, nil), successClosure: { (response) in
            success()
        }) { (error) in
            
        }
    }
    
    /** 评论取消点赞 */
    static func requestCommentsPraiseCancel(_ commentId: String, success: @escaping (() -> ())) {
        Network.default.request(CommonTargetTypeApi.putRequest(RequestCommentsPraiseCancel + commentId, nil), successClosure: { (response) in
            success()
        }) { (error) in
            
        }
    }
    
    /** 视频点赞 */
    static func requestVideoPraise(_ commentId: String, success: @escaping (() -> ())) {
        Network.default.request(CommonTargetTypeApi.postRequest(RequestVideoPraise + commentId, nil), successClosure: { (response) in
            success()
        }) { (error) in
            
        }
    }
    
    /** 视频取消点赞 */
    static func requestVideoPraiseCancel(_ commentId: String, success: @escaping (() -> ())) {
        Network.default.request(CommonTargetTypeApi.putRequest(RequestVideoPraiseCancel + commentId, nil), successClosure: { (response) in
            success()
        }) { (error) in
            
        }
    }
    
}
