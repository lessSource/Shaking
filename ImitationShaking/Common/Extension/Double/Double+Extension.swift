//
//  Double+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension Double {
    
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
    }
    
    // 格式化
    var formatting: String {
        let seconds = lround(self)
        switch seconds {
        case 0..<10:
            return "00:0\(seconds)"
        case 10..<60:
            return "00:\(seconds)"
        default:
            let score = seconds/60
            let remainder = seconds%60
            return (score < 10 ? "0\(score):" : "\(score):") + (remainder < 10 ? "0\(remainder)" : "\(remainder)")
        }
    }
    
}
