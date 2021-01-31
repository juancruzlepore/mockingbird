//
//  DependenciesManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 9/1/21.
//  Copyright © 2021 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class DependeciesManager {
    static func getDependencies(of workout: Workout) -> [Series] {
        workout.dependencies.map({ dep in
            Series(type: WorkoutsManager.instance.getWorkoutFrom(name: dep.workoutName)!, reps: dep.reps, date: DateUtils.today())
        })
    }
}
