//
//  UIDevice+Extension.swift
//  SwiftNoteStudy
//
//  Created by less on 2018/11/13.
//  Copyright © 2018 lj. All rights reserved.
//

import UIKit

extension UIDevice {
    /** iPhoneX */
    public static var isIphoneX: Bool {
        return Constant.screenHeight * UIScreen.main.scale == 2436 ? true : false
    }
    /** iPhoneXS MAX */
    public static var isIphoneXM: Bool {
        return Constant.screenHeight * UIScreen.main.scale == 2688 ? true : false
    }
    /** iPhoneXR */
    public static var isIphoneXR: Bool {
        return Constant.screenHeight * UIScreen.main.scale == 1792 ? true : false
    }
    /** 是否带刘海 */
    public static var isIphone_X: Bool {
        return (isIphoneX || isIphoneXM || isIphoneXR) ? true : false
    }
    
}
