//
//  StreaksManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

protocol HistoryProvider {
    var history: [Series] { get }
    var historyByDay: [DaySeries] { get }
    /// Returns the history by day in a time window
    /// - Parameter from: starting date (inclusive)
    /// - Parameter to: end date (exclusive)
    func getHistoryByDay(from: Date, to: Date, ignoringToday: Bool, orderedInc: Bool) -> [DaySeries]
}

class StreaksManager {
    
    init(historyProvider: HistoryProvider) {
        self.historyProvider = historyProvider
        freq = FrequencyWithCalendarPeriod(period: .WEEK, timesInPeriod: 3, periodStart: DateUtils.getDate(dateString: "29-07-2019")!)
        NotificationCenter.default.addObserver(self,
            selector: #selector(update),
            name: .WorkoutHistoryChanged,
            object: nil
        )
        update()
    }
    
    let historyProvider: HistoryProvider
    let freq: Frequency
    
    var periodTarget: Int { freq.timesInPeriod }
    var timesThisPeriod: Int = 0
    var currentStreak: Int = 0
    
    @objc private func update() {
        currentStreak = getCurrentStreak(withFrequency: freq)
        timesThisPeriod = getTimesThisPeriod(withFrequency: freq)
    }
    
    private func getCurrentStreak(withFrequency freq: Frequency) -> Int {
        switch freq {
        case let freqWithCal as FrequencyWithCalendarPeriod:
            return getCurrentStreakWithCalendarPeriod(withFrequency: freqWithCal)
//        case let freqWithSliding as FrequencyWithSlidingWindow:
//            return try getCurrentStreakWithSlidingWindow(withFrequency: freqWithSliding)
        default:
            return 0
//            throw UnexpectedFrequencyTypeError() // As I am calling it from a View it cannot throw errors
        }
    }
    
    private func getCurrentStreakWithCalendarPeriod(withFrequency freq: FrequencyWithCalendarPeriod) -> Int {
        let days = historyProvider.historyByDay
        let comp = self.compareDays
        if days.count <= 1 {
            os_log("not enought days to calculate streak")
            return days.count
        }

        let today = DateUtils.today()
        let target = freq.timesInPeriod
        var startDate = freq.periodStart
        while(startDate < today){
            startDate += freq.period
        }
        startDate -= freq.period
        startDate -= freq.period
        
        let ignoreToday = days[0].date == today && days[1].score > days[0].score
        var curStreak = 0
        
        var times: UInt
        var endDate = startDate + freq.period
        var prevPeriodDays = historyProvider.getHistoryByDay(from: startDate, to: endDate, ignoringToday: ignoreToday, orderedInc: true)
        var curPeriodDays: [DaySeries]
        repeat {
            times = 0
            curPeriodDays = prevPeriodDays
            prevPeriodDays = historyProvider.getHistoryByDay(from: startDate - freq.period,
                                                             to: endDate - freq.period, ignoringToday: ignoreToday, orderedInc: true)
            var lastScore = prevPeriodDays.last?.score ?? 0
            for d in curPeriodDays {
                if comp(lastScore, d.score) {
                    times += 1
                    lastScore = d.score
                }
            }
            if(times >= target){
                curStreak += 1
            }
            startDate -= freq.period
            endDate -= freq.period
            os_log("times in period: %d", times)
        }
        while(times >= target)
        
        return curStreak
    }
    
    private func getCurrentStreakWithSlidingWindow(withFrequency freq: FrequencyWithSlidingWindow) throws -> Int {
        assert(freq.calendarPeriod == false)
        throw UnexpectedFrequencyTypeError() // FIXME: implement
    }
    
    private func getTimesThisPeriod(withFrequency freq: Frequency) -> Int {
        switch freq {
        case let freqWithCal as FrequencyWithCalendarPeriod:
            return getTimesThisCalendarPeriod(withFrequency: freqWithCal)
//        case let freqWithSliding as FrequencyWithSlidingWindow:
//            return try getCurrentStreakWithSlidingWindow(withFrequency: freqWithSliding)
        default:
            return 0
//            throw UnexpectedFrequencyTypeError() // As I am calling it from a View it cannot throw errors
        }
    }
    
    private func getTimesThisCalendarPeriod(withFrequency freq: FrequencyWithCalendarPeriod) -> Int {
        let comp = self.compareDays
        let today = DateUtils.today()
        var startDate = freq.periodStart
        while(startDate < today){
            startDate += freq.period
        }
        startDate -= freq.period
        
        let endDate = startDate + freq.period
        let prevPeriodDays = historyProvider.getHistoryByDay(from: startDate - freq.period, to: endDate - freq.period, ignoringToday: false, orderedInc: true)
        let curPeriodDays = historyProvider.getHistoryByDay(from: startDate, to: endDate, ignoringToday: false, orderedInc: true)
        var lastScore = prevPeriodDays.last?.score ?? 0
        var times = 0
        for d in curPeriodDays {
            if comp(lastScore, d.score) {
                times += 1
                lastScore = d.score
            }
        }
        return times
    }
    
    func getWeekOverWeekRatio() -> Float? {
        let lastWeekScore = Utils.getLastWeekScore(from: historyProvider.history)
        let penultimateWeekScore = Utils.getPenultimateWeekScore(from: historyProvider.history)
        if (lastWeekScore == 0 || penultimateWeekScore == 0) {
            return nil
        }
        return lastWeekScore / penultimateWeekScore
    }
    
    private func compareDays(previous: Float, new: Float) -> Bool {
        return new > previous
    }
}
