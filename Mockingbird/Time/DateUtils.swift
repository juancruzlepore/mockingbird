//
//  DateUtils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

extension Date {
    static func +(left: Date, right: Day) -> Date {
        return DateUtils.addDays(amount: right.number, to: left)
    }
    
    static func -(left: Date, right: Day) -> Date {
        return DateUtils.addDays(amount: -right.number, to: left)
    }
    
    static func +(left: Date, right: Week) -> Date {
        return DateUtils.addDays(amount: right.number * 7, to: left)
    }
    
    static func +(left: Date, right: Period) -> Date {
        return DateUtils.addDays(amount: Int(right.rawValue.days), to: left)
    }
    
    static func -(left: Date, right: Period) -> Date {
        return DateUtils.addDays(amount: -Int(right.rawValue.days), to: left)
    }
    
    static func +=(left: inout Date, right: Period) {
        left = DateUtils.addDays(amount: Int(right.rawValue.days), to: left)
    }
    
    static func -=(left: inout Date, right: Period) {
        left = DateUtils.addDays(amount: -Int(right.rawValue.days), to: left)
    }
}

final class DateUtils {
    public let dateFormatterStore = DateFormatter()
    public let dateFormatterShow = DateFormatter()
    public let dateFormatterShortDayOfWeek = DateFormatter()
    public static let SECOND: TimeInterval = 1
    public static let MINUTE: TimeInterval = 60
    public static let HOUR: TimeInterval = 60 * MINUTE
    public static let DAY: TimeInterval = 24 * HOUR
    public static let WEEK: TimeInterval = 7 * DAY
    public static var oneMonthAgo: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    }
    public static var twoWeeksAgo: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!
    }

    private static let dateFormatStore = "dd-MM-yyyy"
    private static let dateFormatShow = "MMM dd, yyyy"
    private static let dateFormatShortDayOfWeek = "EEE dd/MM"
    
    
    static let instance = DateUtils()
    
    private init(){
        dateFormatterStore.dateFormat = DateUtils.dateFormatStore
        dateFormatterStore.timeZone = TimeZone.current
        dateFormatterStore.locale = Locale.current
        
        dateFormatterShow.dateFormat = DateUtils.dateFormatShow
        dateFormatterShortDayOfWeek.dateFormat = DateUtils.dateFormatShortDayOfWeek
        
    }
    
    static func toStore(date: Date) -> String {
        return instance.dateFormatterStore.string(from: date)
    }
    
    static func toShow(date: Date) -> String {
        return instance.dateFormatterShow.string(from: date)
    }
    
    static func getDate(dateString: String) -> Date? {
        return instance.dateFormatterStore.date(from: dateString)
    }
    
    static func yesterday() -> Date {
        return today() - Day(1)
    }
    
    static func today() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    static func isToday(date: Date) -> Bool {
        return Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedSame
    }
    
    static func tomorrow() -> Date {
        return today() + Day(1)
    }
    
    static func addDays(amount: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: amount, to: date)!
    }
    
    static func addDaysToToday(amount: Int) -> Date {
        return DateUtils.addDays(amount: amount, to: DateUtils.today())
    }
    
    static func addWeeksToToday(amount: Int) -> Date {
        return DateUtils.addDays(amount: amount * 7, to: DateUtils.today())
    }
    
    static func toShowWithWeekDay(date: Date) -> String {
        return instance.dateFormatterShortDayOfWeek.string(from: date)
    }

}
