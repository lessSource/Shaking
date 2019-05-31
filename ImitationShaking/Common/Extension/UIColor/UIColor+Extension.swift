//
//  UIColor+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension UIColor {
    /** 主色 */
    public class var mainColor: UIColor {
        return withHex(hexString: "#3D9DFD")
    }

    /** 字体颜色 */
    public class var textColor_333333: UIColor {
        return withHex(hexString: "#333333")
    }
    
    public class var textColor_666666: UIColor {
        return withHex(hexString: "#666666")
    }
    
    public class var textColor_999999: UIColor {
        return withHex(hexString: "#999999")
    }
    
    /** 线的颜色 */
    public class var lineColor_191D20: UIColor {
        return withHex(hexString: "#191D20")
    }
    
    /** 弹出框颜色 */
    public class var popUpColor_2F2F2F: UIColor {
        return UIColor.withHex(hexString: "#2F2F2F", alpha: 0.99)
    }

    
    class func withHex(hexString hex: String, alpha: CGFloat = 1) -> UIColor {
        // 去除空格
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        Scanner(string: cString[0..<2]).scanHexInt32(&red)
        Scanner(string: cString[2..<4]).scanHexInt32(&green)
        Scanner(string: cString[4..<6]).scanHexInt32(&blue)
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
}


