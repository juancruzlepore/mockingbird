//
//  StreaksManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

protocol HistoryProvider {
    var history: [Series] { get }
    var historyByDay: [DaySeries] { get }
}

class StreaksManager {
    
    init(historyProvider: HistoryProvider) {
        self.historyProvider = historyProvider
    }
    
    let historyProvider: HistoryProvider
    
    func getCurrentStreak() -> Int {
        let today = DateUtils.today()
        let days = self.historyProvider.historyByDay
        if days.count <= 1 { return days.count }
        var curStreak = 1
//        let linger = 0
        var streakStart = 0
        if days[0].date == today && days[1].score > days[0].score {
            streakStart = 1
        }
        var i = streakStart
//        var toSkip = linger
        while (i + 1 < days.count
            && days[i].score > days[i + 1].score
            && days[i + 1].date.distance(to: days[i].date) == DateUtils.DAY) {
            curStreak += 1
            i += 1
        }
        return curStreak
    }
    
    func getWeekOverWeekRatio() -> Float? {
        let lastWeekScore = Utils.getLastWeekScore(from: historyProvider.history)
        let penultimateWeekScore = Utils.getPenultimateWeekScore(from: historyProvider.history)
        if (lastWeekScore == 0 || penultimateWeekScore == 0) {
            return nil
        }
        return lastWeekScore / penultimateWeekScore
    }
    
}
