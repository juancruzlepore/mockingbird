//
//  Frequency.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

enum Period: Int {
    case DAY = 1
    case WEEK = 7
    case FORTNITE = 14
    case MONTH = 30
    case YEAR = 365
    case CUSTOM = -1
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
        self.periodStart = periodStart
        super.init(period: period, timesInPeriod: timesInPeriod, calendarPeriod: true)
    }
}

class FrequencyWithSlidingWindow: Frequency {
    
    init(period: Period, timesInPeriod: Int){
        super.init(period: period, timesInPeriod: timesInPeriod, calendarPeriod: false)
    }
}

