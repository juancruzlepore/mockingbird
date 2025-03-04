//
//  WorkOut.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

typealias SeriesFilter = (Series) -> Bool
typealias MuscleFilter = (MuscleGroup) -> Bool

struct WorkoutFilter {
    let seriesFilter: SeriesFilter
    let muscleFilter: MuscleFilter
    
    func apply(series: Series) -> Bool {
        return series.workout.getValues(muscleFilter: muscleFilter) > 0.0
            && seriesFilter(series)
    }
    
    init(seriesFilter: @escaping SeriesFilter, muscleFilter: @escaping MuscleFilter) {
        self.seriesFilter = seriesFilter
        self.muscleFilter = muscleFilter
    }
}

struct Dependency: Codable {
    let workoutName: String
    let reps: Int
}

class Workout: Hashable, Identifiable, Codable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.name == rhs.name
    }
    
    private static var counter: Int = 0
    private static func nextId() -> Int {
        Workout.counter += 1
        return Workout.counter
    }
    
    public let id: Int
    
    func hash(into hasher: inout Hasher){
        hasher.combine(name)
    }
    
    public let name: String
    public var value: Float {
        values.values.reduce(0) {$0 + $1}
    }
    
    public let values: [MuscleGroup:Float]
    public let movementType: MovementType
    public let dependencies: [Dependency]
    public var mainMuscle: MuscleGroup {
        self.values.max(by: {a, b in a.value < b.value})?.key ?? .ABS
    }
    
    init(name: String,
         values: [MuscleGroup:Float],
         movementType: MovementType,
         dependencies: [Dependency] = []) {
        self.name = name
        self.values = values
        self.movementType = movementType
        self.id = Workout.nextId()
        self.dependencies = dependencies
    }
    
    public func getValues(muscleFilter: MuscleFilter) -> Float {
        return values.filter { muscleFilter($0.key) }.reduce(0) {$0 + $1.value}
    }
}
