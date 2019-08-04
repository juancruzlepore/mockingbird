//
//  FilteredHistoryProvider.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class FilteredHistoryProvider: HistoryProvider {
    let wom = WorkOutsManager.instance
    let filter: WorkoutFilter
    
    init(filter: WorkoutFilter){
        self.filter = filter
    }
    
    var history: [Series] {
        wom.history.filter { filter.seriesFilter($0) }
    }
}
