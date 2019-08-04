//
//  Target.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 3/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

struct Target {
    let freq: Frequency
    let name: String
    let seriesFilter: SeriesFilter
    let muscleFilter: MuscleFilter
    
    init(frequency: Frequency,
         name: String,
         seriesFilter: @escaping SeriesFilter = { _ in true },
         muscleFilter: @escaping MuscleFilter = { _ in true }) {
        self.freq = frequency
        self.name = name
        self.seriesFilter = seriesFilter
        self.muscleFilter = muscleFilter
    }
}
