//
//  String+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/31.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    /** 时间戳转date */
    var timeStampDate: Date {
        guard let time = TimeInterval(self) else {
            return Date()
        }
        return Date(timeIntervalSince1970: time)
    }
    
    /** 判断字符串是否是数字 */
    var isPurnInt: Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /** 密码验证 6-12为字母和数字组合 */
    var isPasswordRuler: Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@", passwordRule)
        return regexPassword.evaluate(with: self)
    }
    
    /** MD5加密 */
    func md5() -> String {
        let string = self.cString(using: String.Encoding.utf8)
        let stringLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(string!, stringLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02X", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    /** 获取文字高度 */
    func heightWithStringAttributes(attributes: [NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16)], fixedWidth: CGFloat) -> CGFloat {
        guard count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    /** 设置文字部分高亮 */
    func stringHighlighted(_ string: String, color: UIColor) -> NSMutableAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let str = NSString(string: self)
        let range = str.range(of: string)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attrString
    }
    
    /** 随机字符串 */
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len: Int) -> String {
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    /** 时间戳转时间 */
    func timestampTime(_ dateFormat: String = Date.dateFormatDay) -> String {
        guard let timeInterval: TimeInterval = TimeInterval(self) else {
            return self
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /** 字符串转时间戳 */
    func stringToTimeStamp(_ dateFormat: String = Date.dateFormatDay) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        let dateStamp: TimeInterval = date.timeIntervalSince1970
        return String(dateStamp)
    }
}
