//
//  TargetHandler.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class TargetHandler: ObservableObject {
    static let defaultTarget = TargetHandler(
        target: Settings.defaultTarget)
    
    @Published var version: Int
    @ObservedObject var wom: WorkoutsManager = WorkoutsManager.instance
    
    let target: Target
    let historyProvider: HistoryProvider
    let streaks: StreaksManager
    var workouts: [Workout] {
        WorkoutDefinitions.descriptions.filter({ $0.values.contains(where: { (e) -> Bool in target.muscleFilter(e.key) }) })
    }
    
    /// Weeks before current one, 0 means current week
    func historyProviderFor(week: Int) -> HistoryProvider {
        return FilteredHistoryProvider(
            workoutFilter: target.workoutFilter,
            dateInterval: (target.freq as! FrequencyWithCalendarPeriod).getPeriodIntervalFor(week: week))
    }
    
    init(target: Target){
        self.target = target
        let newHistoryProvider = FilteredHistoryProvider(
            workoutFilter: target.workoutFilter)
        self.historyProvider = newHistoryProvider
        self.streaks = StreaksManager(historyProvider: newHistoryProvider, frequency: target.freq)
        self.version = 0
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: .WorkoutHistoryChanged,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(update),
                                               name: .NSCalendarDayChanged,
                                               object: nil
        )
    }
    
    @objc private func update() {
        self.version += 1
    }
}
