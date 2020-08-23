//
//  FilteredHistoryProvider.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

struct FilteredHistoryProvider: HistoryProvider {
    let wom = WorkoutsManager.instance
    let workoutFilter: WorkoutFilter?
    let dateInterval: DateInterval?
    
    init(workoutFilter: WorkoutFilter? = nil, dateInterval: DateInterval? = nil){
        self.workoutFilter = workoutFilter
        self.dateInterval = dateInterval
    }
    
    var history: [Series] {
        wom.getHistory().filter {
            workoutFilter?.apply(series: $0) ?? true
        } .filter {
            dateInterval?.contains($0.date) ?? true
        }
        .map { (s) -> FilteredSeries in
            FilteredSeries(base: s, filter: self.workoutFilter?.muscleFilter)
        }
    }
}
