//
//  Constant.swift
//  SwiftNoteStudy
//
//  Created by less on 2018/11/13.
//  Copyright © 2018 lj. All rights reserved.
//

import UIKit

struct Constant {
    /** 屏幕宽度 */
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    /** 屏幕高度 */
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    /** 状态栏高度 */
    public static var statusHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    /** navtiveTitleView高度 */
    public static var topBarHeight: CGFloat {
        return 44.0
    }
    /** 头部高度 */
    public static var navbarAndStatusBar: CGFloat {
        return (statusHeight + topBarHeight)
    }
    /** 标签栏 */
    public static var bottomBarHeight: CGFloat {
        return UIDevice.isIphone_X ? 83.0 : 49.0
    }
    
    /** 安全边界 */
    public static var barHeight: CGFloat {
        return UIDevice.isIphone_X ? 34.0 : 0.0
    }
    
    public static var barMargin: CGFloat {
        return UIDevice.isIphone_X ? 20.0 : 0.0
    }
    
    /**  */
    public static var sizeScale: CGFloat {
        return screenWidth > 320 ? screenWidth/375.0 : 1
    }
    
    /** 线高 */
    public static var lineHeight: CGFloat {
        return 0.5
    }
}
