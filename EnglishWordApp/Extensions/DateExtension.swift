//
//  DateExtension.swift
//  EnglishWordApp
//
//  Created by headspinnerd on 2019/10/17.
//  Copyright © 2019 headspinnerd. All rights reserved.
//

import Foundation

public extension Date {

    static func substractDate(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
    
//    static func someDaysAgo(days: Int) -> NSDate {
//        var dateComponent = DateComponents()
//
//        dateComponent.day = -days
//
//        let date = Calendar.current.date(byAdding: dateComponent, to: Date())
//        let defaultDate = Date(timeIntervalSince1970: TimeInterval(0))
//        let result = NSDate(timeInterval: TimeInterval(0), since: date ?? defaultDate)
//
//        return result
//    }
}
