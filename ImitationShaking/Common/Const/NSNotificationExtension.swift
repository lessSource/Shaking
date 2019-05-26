//
//  NSNotificationExtension.swift
//  FiveLine
//
//  Created by guowk on 2018/9/5.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

import UIKit

class WTNotificationName: NSObject {
    /** 购物车商品通知 */
    static let DeleteGoodsNotify = NSNotification.Name("keyDeleteGoodsNotify")
    
    /** 操作完成后数据更新 */
    static let NotificationSuccessKey = NSNotification.Name("NotificationSuccessKey")
    
    /** 清除筛选数据 */
    static let RemoveDataKey = NSNotification.Name("keyRemoveDataKey")
    
    /** 推送界面刷新 */
    static let NotificationPushKey = NSNotification.Name("NotificationPushKey")
}
