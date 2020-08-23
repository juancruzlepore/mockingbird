//
//  UsageStats.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 16/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class UsageStats {
    static let instance = UsageStats(historyProvider: TargetHandler.defaultTarget.historyProvider)
    
    let history: HistoryProvider
    let lastMonthHistory: [DaySeries]
    let lastTwoWeeksHistory: [DaySeries]
    
    init(historyProvider: HistoryProvider){
        self.history = historyProvider
        self.lastMonthHistory = historyProvider.getHistoryByDay(from: DateUtils.oneMonthAgo)
        self.lastTwoWeeksHistory = historyProvider.getHistoryByDay(from: DateUtils.twoWeeksAgo)
    }
    
    func getTopNReps(n: Int) -> [Int] {
        return lastMonthHistory
            .flatMap({$0.allSeries.map({$0.repetitions})})
            .reduce(into: [Int:Int](), { dict, rep  in
                if (dict[rep] == nil) {
                    dict[rep] = 0
                }
                dict[rep]! += 1
            })
            .sorted(by: { e1, e2 in return e1.value > e2.value })
            .prefix(n)
            .map({$0.key})
    }
    
    func getTopNWorkouts(n: Int) -> [Workout] {
        return lastMonthHistory
            .flatMap({$0.allSeries.map({$0.workout})})
            .reduce(into: [Workout:Int](), { dict, workout  in
                if (dict[workout] == nil) {
                    dict[workout] = 0
                }
                dict[workout]! += 1
            })
            .sorted(by: { e1, e2 in return e1.value > e2.value })
            .prefix(n)
            .map({$0.key})
    }
}
