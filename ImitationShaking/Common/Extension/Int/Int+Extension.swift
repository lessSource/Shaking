
//
//  Int+Extension.swift
//  ImitationShaking
//
//  Created by less on 2019/6/3.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension Int {
    
    // 格式化
    var formatting: String {
        switch self {
        case 0..<10000:
            return "\(self)"
        default:            
            return String(format: "%.1fW", CGFloat(self)/10000.0)
        }
    }
    
}
