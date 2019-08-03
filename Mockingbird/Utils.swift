//
//  Utils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 25/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var WorkoutHistoryChanged: Notification.Name {
        return .init(rawValue: "WorkoutHistoryChanged")
    }
}

class Utils {
    static func getScore(from series: [Series], after start: Date, before end: Date) -> Float {
        series.filter({$0.date >= start && $0.date < end}).reduce(0.0) { (r, s) -> Float in
            r + s.score
        }
    }
    
    static func getLastWeekScore(from series: [Series]) -> Float {
        return Utils.getScore(from: series, after: DateUtils.addWeeksToToday(amount: -1), before: DateUtils.today())
    }
    
    static func getPenultimateWeekScore(from series: [Series]) -> Float {
        return Utils.getScore(from: series, after: DateUtils.addWeeksToToday(amount: -2), before: DateUtils.addWeeksToToday(amount: -1))
    }
}
