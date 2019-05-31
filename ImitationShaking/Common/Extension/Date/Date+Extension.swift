//
//  Date+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/31.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

extension Date {
    
    // dateFormat
    static var dateFormatDay: String {
        return "yyyy-MM-dd"
    }
    
    static var dateFormatSeconds: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
    static var dateFormatZone: String {
        return "yyyy-MM-dd 'T'HH:mm:ss.SSS+SSSS'Z'"
    }
    
    // 当前时间戳
    static var millisends: TimeInterval {
        get { return Date().timeIntervalSince1970 * 1000 }
    }
    
    // 当前星期
    static func week() -> String {
        let weekDay: Int = Calendar.current.component(Calendar.Component.weekday, from: Date())
        switch weekDay {
        case 0: return "周六"
        case 1: return "周日"
        case 2: return "周一"
        case 3: return "周二"
        case 4: return "周三"
        case 5: return "周四"
        case 6: return "周五"
        default: return "未取到数据"
        }
    }
    
    // 格式化时间
    func formattingDate(_ dateFormat: String = dateFormatDay) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: self)
    }
    
    // 间隔多少秒
    static func secondsBetweenDate(start: Date, end: Date) -> Int {
        let components = Calendar.current.dateComponents([.day,.second], from: start, to: end)
        return components.second ?? 0
    }
    
    // 距多长时间
    static func compareCurrentTime(timeStamp: Int) -> String {
        if timeStamp <= 0 { return "0秒" }
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        var timeInterval = date.timeIntervalSinceNow
        timeInterval = -timeInterval
        let time: Int = Int(timeInterval)
        var result: String
        if timeInterval < 60 {
            result = "\(time)秒"
        }else if timeInterval/60 < 60 {
            result = "\(time/60)分钟\(time%60)秒"
        }else {
            result = "\(time/60/60)小时\(time/60%60)分钟\(time%60)秒"
        }
        return result
    }
    
    static func timeAgoSinceDate(_ date: Date, mumericDates: Bool = true) -> String {
        let calendar = Calendar.current
        let now = Date()
        if date > now {
            return date.formattingDate(Date.dateFormatSeconds)
        }
        let compinents: DateComponents = calendar.dateComponents([.second,.minute,.hour,.day,.weekOfYear,.month,.year], from: date, to: now)
        guard let year = compinents.year, let month = compinents.month, let weekOfYear = compinents.weekOfYear, let day = compinents.day, let hour = compinents.hour, let minute = compinents.minute, let second = compinents.second else {
            return "未获取到数据"
        }
        if year >= 2 {
            return "\(year)年前"
        }else if year >= 1 {
            if mumericDates { return "1年前" }
            return "去年"
        }else if month >= 2 {
            return "\(month)月前"
        }else if month >= 1 {
            if mumericDates { return "1个月前" }
            return "上个月"
        }else if weekOfYear >= 2 {
            return "\(weekOfYear)周前"
        }else if weekOfYear >= 1 {
            if mumericDates { return "1周前" }
            return "上周"
        }else if day >= 2 {
            return "\(day)天前"
        }else if day >= 1 {
            if mumericDates { return "1天前" }
            return "昨天"
        }else if hour >= 1 {
            return "\(hour)小时前"
        }else if minute >= 1 {
            return "\(minute)分钟前"
        }else if second >= 5 {
            return "\(second)秒前"
        }else {
            return "刚刚"
        }
        
    }
    
}
