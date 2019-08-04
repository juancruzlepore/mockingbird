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
    
    init(seriesFilter: @escaping SeriesFilter, muscleFilter: @escaping MuscleFilter) {
        self.seriesFilter = seriesFilter
        self.muscleFilter = muscleFilter
    }
}

class WorkOut: Hashable, Identifiable {
    static func == (lhs: WorkOut, rhs: WorkOut) -> Bool {
        lhs.name == rhs.name
    }
    
    private static var counter: Int = 0
    private static func nextId() -> Int {
        WorkOut.counter += 1
        return WorkOut.counter
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
    
    init(name: String, values: [MuscleGroup:Float], movementType: MovementType) {
        self.name = name
        self.values = values
        self.movementType = movementType
        self.id = WorkOut.nextId()
    }
    
    public func getValues(muscleFilter: MuscleFilter) -> Float {
        return values.filter { muscleFilter($0.key) }.reduce(0) {$0 + $1.value}
    }
}
