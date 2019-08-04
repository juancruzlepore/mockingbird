//
//  FilteredHistoryProvider.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

class FilteredHistoryProvider: HistoryProvider {
    let wom = WorkOutsManager.instance
    let filter: WorkoutFilter
    
    init(filter: WorkoutFilter){
        self.filter = filter
    }
    
    var history: [Series] {
        wom.getHistory().filter {
            filter.seriesFilter($0)
            && $0.type.getValues(muscleFilter: filter.muscleFilter) > 0.0
        } .map { (s) -> FilteredSeries in
            FilteredSeries(base: s, filter: self.filter.muscleFilter)
        }
    }
}
