//
//  NSObject+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/31.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    // 用于获取cell的reuse identifire
    class var identifire: String {
        return String(format: "%@_identifire", self.nameOfClass)
    }
    
}
