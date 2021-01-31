//
//  Frequency.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class PeriodData: Equatable, ExpressibleByStringLiteral {
    
    let days: UInt
    let singularName: String
    let pluralName: String
    
    public static func == (lhs: PeriodData, rhs: PeriodData) -> Bool {
        return (lhs.days == rhs.days && lhs.singularName == rhs.singularName)
    }
    
    public required init(stringLiteral value: String) {
        let components = value.components(separatedBy: ",")
        if components.count == 3 {
            self.days = UInt(components[0])!
            self.singularName = components[1]
            self.pluralName = components[2]
        } else {
            self.days = 1
            self.singularName = "ERROR"
            self.pluralName = "ERROR"
        }
        
    }
    
    init(days: UInt, singularName: String, pluralName: String){
        self.days = days
        self.singularName = singularName
        self.pluralName = pluralName
    }
}

enum Period: PeriodData {
        
    case DAY = "1,day,days"
    case WEEK = "7,week,weeks"
    case FORTNIGHT = "14,fortnight,fortnights"
    case MONTH = "30,month,months"
    case YEAR = "365,year,years"
    case CUSTOM = "-1"
}

/// Class that encapsulates how often one should be working out, mainly to calculate the current streak
class Frequency {
    public let period: Period
    public let timesInPeriod: Int
    public let calendarPeriod: Bool;
    
    /// - Parameter period: period of time for the routine to be repeated
    /// - Parameter timesInPeriod: number of days in the period
    /// - Parameter calendarPeriod: calendarPeriod means that we are not using a sliding window to do the check. For example, if someone works out 3 times a week, one week on Mon, Tue, and Wed, and the next one on Fri, Sat, un Sun, with a sliding window it would have been an entire week without workouts, but with calendar week it would be ok.
    init(period: Period, timesInPeriod: Int, calendarPeriod: Bool = true){
        self.period = period
        self.timesInPeriod = timesInPeriod
        self.calendarPeriod = calendarPeriod;
    }
}

class FrequencyWithCalendarPeriod: Frequency {
    
    let periodStart: Date
    
    init(period: Period, timesInPeriod: Int, periodStart: Date){
        self.periodStart = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: periodStart)!
        super.init(period: period, timesInPeriod: timesInPeriod, calendarPeriod: true)
    }
    
    var currentPeriodStart: Date {
        getPeriodStartFor(week: 0)
    }
    
    var currentPeriodEnd: Date {
        getPeriodEndFor(week: 0)
    }
    
    var currentPeriodInterval: DateInterval {
        getPeriodIntervalFor(week: 0)
    }
    
    var completedPeriods: Double {
        switch self.period {
        case .WEEK:
            return DateInterval(start: self.periodStart, end: Date()).duration / (7 * 24 * 60 * 60)
        default:
            return 0 // should throw error
        }
    }
    
    var currentPeriodCompletionRatio: Double {
        completedPeriods - floor(completedPeriods)
    }
    
    /// Curreen week = 0, 1 is last week and so on
    func getPeriodStartFor(week: Int) -> Date {
        var dateComponents = DateComponents()
        switch self.period {
        case .WEEK:
            dateComponents.day = 7 * (Int(floor(completedPeriods)) - week)
        default:
            return Date() // should throw error
        }
        return Calendar.current.date(byAdding: dateComponents, to: self.periodStart)!
    }
    
    func getPeriodEndFor(week: Int) -> Date {
        let start = getPeriodStartFor(week: week)
        var dateComponents = DateComponents()
        switch self.period {
        case .WEEK:
            dateComponents.day = 7
        default:
            return Date() // should throw error
        }
        return Calendar.current.date(byAdding: dateComponents, to: start)!
    }
    
    func getPeriodIntervalFor(week: Int) -> DateInterval {
        return DateInterval(
            start: getPeriodStartFor(week: week),
            end: getPeriodEndFor(week: week))
    }
    
    func daysLeftThisPeriod(includingToday: Bool) -> Int {
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: currentPeriodEnd).day!
        return daysLeft + (includingToday ? 1 : 0)
    }
}

class FrequencyWithSlidingWindow: Frequency {
    
    init(period: Period, timesInPeriod: Int){
        super.init(period: period, timesInPeriod: timesInPeriod, calendarPeriod: false)
    }
}

