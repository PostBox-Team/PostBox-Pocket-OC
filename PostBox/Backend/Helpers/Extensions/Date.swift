//
//  Date.swift
//  PostBox
//
//  Created by b0kch01 on 11/20/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

extension Date {
    /// Returns a string for the time interval
    
    // en
    func getElapsedInterval(_ suffix: Bool = false) -> String {
        
        let preferredLanguage = NSLocale.preferredLanguages[0]
        
        var final = ""
        var output = ""

        if preferredLanguage == "zh-Hans" {
            let interval = Calendar.current.dateComponents(
                [.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: Date()
            )

            if self == Date.distantFuture { return "未知" }
                        
            if let year = interval.year, year > 0 {
                output = "\(year)" + "年"
            } else if let month = interval.month, month > 0 {
                output = "\(month)" + "月"
            } else if let week = interval.weekOfMonth, week > 0 {
                output = "\(week)" + "星期"
            } else if let day = interval.day, day > 0 {
                output = "\(day)" + "天"
            } else if let hour = interval.hour, hour > 0 {
                output = "\(hour)" + "小时"
            } else if let minute = interval.minute, minute > 0 {
                output = "\(minute)" + "分钟"
            } else if let second = interval.second, second > 0 {
                output = "\(second)" + "秒"
            } else {
                return "刚刚更新"
            }
            
            final = output + (suffix ? "前" : "")
        } else if preferredLanguage == "zh-Hant" {
            let interval = Calendar.current.dateComponents(
                [.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: Date()
            )

            if self == Date.distantFuture { return "未知" }
                        
            if let year = interval.year, year > 0 {
                output = "\(year)" + "年"
            } else if let month = interval.month, month > 0 {
                output = "\(month)" + "月"
            } else if let week = interval.weekOfMonth, week > 0 {
                output = "\(week)" + "星期"
            } else if let day = interval.day, day > 0 {
                output = "\(day)" + "天"
            } else if let hour = interval.hour, hour > 0 {
                output = "\(hour)" + "小時"
            } else if let minute = interval.minute, minute > 0 {
                output = "\(minute)" + "分鐘"
            } else if let second = interval.second, second > 0 {
                output = "\(second)" + "秒"
            } else {
                return "刚刚更新"
            }
            
            final = output + (suffix ? "前" : "")
        } else {
            let interval = Calendar.current.dateComponents(
                [.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: self, to: Date()
            )
            
            if self == Date.distantFuture { return "Unknown" }
            
            if let year = interval.year, year > 0 {
                output = year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
            } else if let month = interval.month, month > 0 {
                output = month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
            } else if let week = interval.weekOfMonth, week > 0 {
                output = week == 1 ? "\(week)" + " " + "week" :
                "\(week)" + " " + "weeks"
            } else if let day = interval.day, day > 0 {
                output = day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
            } else if let hour = interval.hour, hour > 0 {
                output = hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
            } else if let minute = interval.minute, minute > 0 {
                output = minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
            } else if let second = interval.second, second > 0 {
                output = second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds"
            } else {
                return "a moment ago"
            }
            
            final = output + (suffix ? " ago" : "")
        }
        
        return final
    }
    
    func generalPrecision() -> String {
        let preferredLanguage = NSLocale.preferredLanguages[0]
        
        var final = ""
        var output = ""
        
        if preferredLanguage == "zh-Hans" {
            if self == Date.distantFuture { return "将来" }

            let interval = Calendar.current.dateComponents(
                [.day], from: self, to: Date()
            )
            
            switch interval.day {
            case 0: output += "今天"
            case 1: output += "昨天"
            default: return DateFormatter.monthDate.string(from: self)
            }
            
            final = output + DateFormatter.time.string(from: self)
        } else if preferredLanguage == "zh-Hant" {
            if self == Date.distantFuture { return "將來" }

            let interval = Calendar.current.dateComponents(
                [.day], from: self, to: Date()
            )
            
            switch interval.day {
            case 0: output += "今天"
            case 1: output += "昨天"
            default: return DateFormatter.monthDate.string(from: self)
            }
            
            final = output + DateFormatter.time.string(from: self)
        } else {
            if self == Date.distantFuture { return "In the future" }
            
            let interval = Calendar.current.dateComponents(
                [.day], from: self, to: Date()
            )
            
            switch interval.day {
            case 0: output += "Today "
            case 1: output += "Yesterday "
            default: return DateFormatter.monthDate.string(from: self)
            }
            
            final = output + DateFormatter.time.string(from: self)
        }
        
        return final
    }
}

extension DateFormatter {
    /// Formats `Date` object into `M.d.yy` (used in PostBox)
    static let postbox: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("M.d.yy")
        return formatter
    }()
    
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("h:mm a")
        return formatter
    }()
    
    static let monthDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return formatter
    }()
}
