//
//  HistoryProvider.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

extension HistoryProvider {
    
    var historyByDay: [DaySeries] {
        let historyMap = Utils.mapByDate(series: self.history)
        let history = [DaySeries](historyMap.values)
        
        return history.sorted {$0.date > $1.date}
    }

    func getHistoryByDay(from start: Date, to end: Date, ignoringToday: Bool = false, orderedInc: Bool = true) -> [DaySeries] {
        let today = DateUtils.today()
        let daysOrederedDec = self.historyByDay.filter {
            $0.date >= start && $0.date < end && (!ignoringToday || $0.date != today)
        }
        if orderedInc {
            return daysOrederedDec.reversed()
        }
        return daysOrederedDec
    }
    
    func getHistoryByDay(from start: Date) -> [DaySeries] {
        return self.historyByDay.filter {
            $0.date >= start
        }
    }

}

protocol HistoryProvider {
    var history: [Series] { get }
    var historyByDay: [DaySeries] { get }
    
    /// Returns the history by day in a time window
    /// - Parameter from: starting date (inclusive)
    /// - Parameter to: end date (exclusive)
    func getHistoryByDay(from: Date, to: Date, ignoringToday: Bool, orderedInc: Bool) -> [DaySeries]
}
