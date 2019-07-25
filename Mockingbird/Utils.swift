//
//  Utils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 25/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class Utils {
    static func getScore(from series: [Series], after start: Date, before end: Date) -> Float {
        series.filter({$0.date >= start && $0.date < end}).reduce(0.0) { (r, s) -> Float in
            r + s.score
        }
    }
    
    static func getLastWeekScore(from series: [Series]) -> Float {
        return Utils.getScore(from: series, after: DateUtils.addDaysToToday(amount: 7), before: DateUtils.today())
    }
}
