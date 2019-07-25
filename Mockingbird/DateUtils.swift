//
//  DateUtils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

final class DateUtils {
    private let dateFormatterStore = DateFormatter()
    private let dateFormatterShow = DateFormatter()
    public static let SECOND: TimeInterval = 1
    public static let MINUTE: TimeInterval = 60
    public static let HOUR: TimeInterval = 60 * MINUTE
    public static let DAY: TimeInterval = 24 * HOUR
    
    private static let dateFormatStore = "dd-MM-yyyy"
    private static let dateFormatShow = "MMM dd, yyyy"
    
    static let instance = DateUtils()
    
    private init(){
        dateFormatterStore.dateFormat = DateUtils.dateFormatStore
        dateFormatterStore.timeZone = TimeZone.current
        dateFormatterStore.locale = Locale.current
        
        dateFormatterShow.dateFormat = DateUtils.dateFormatShow
        
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
    
    static func today() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    static func addDays(amount: Int, to date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: amount, to: date)!
    }
    
    static func addDaysToToday(amount: Int) -> Date {
        return DateUtils.addDays(amount: amount, to: DateUtils.today())
    }
        
}
