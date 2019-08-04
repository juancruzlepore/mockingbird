//
//  FilteredSeries.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class FilteredSeries: Series {
    let filter: MuscleFilter
    
    override public var score: Float {
        self.getScore(muscleFilter: filter)
    }
    
    init(base: Series, filter: @escaping MuscleFilter){
        self.filter = filter
        super.init(type: base.type, reps: base.repetitions, date: base.date)
    }
}
