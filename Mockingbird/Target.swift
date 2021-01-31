//
//  Target.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 3/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import Combine
import os.log

class Target: ObservableObject, Identifiable {
    private static var counter: Int = 0
    private static func nextId() -> Int {
        Target.counter += 1
        return Target.counter
    }
    
    public let id: Int
    
    let willChange = ObservableObjectPublisher()
    @Published var version: Int
    
    let freq: FrequencyWithCalendarPeriod
    let name: String
    let seriesFilter: SeriesFilter
    let muscleFilter: MuscleFilter
    var workoutFilter: WorkoutFilter {
        WorkoutFilter(seriesFilter: seriesFilter, muscleFilter: muscleFilter)
    }
    
    init(frequency: FrequencyWithCalendarPeriod,
         name: String,
         seriesFilter: @escaping SeriesFilter = { _ in true },
         muscleFilter: @escaping MuscleFilter = { _ in true }) {
        self.freq = frequency
        self.name = name
        self.seriesFilter = seriesFilter
        self.muscleFilter = muscleFilter
        self.version = 0
        self.id = Target.nextId()
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(update),
            name: .WorkoutHistoryChanged,
            object: nil
        )
        os_log("Target number: %d", self.id)
    }
    
    @objc private func update() {
        self.version += 1
    }
}
