//
//  Series.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

class Series: Identifiable {
    
    private static var counter: Int = 0
    private static func nextId() -> Int {
        Series.counter += 1
        return Series.counter
    }
    
    public let id: Int
    public let type: WorkOut
    public let repetitions: Int
    public let date: Date
    public var score: Float {
        Float(repetitions) * type.value
    }
    
    init(type: WorkOut, reps: Int, date: Date){
        self.id = Series.nextId()
        self.type = type
        self.repetitions = reps
        self.date = date
    }
    
    public func getScore(muscleFilter: MuscleFilter) -> Float {
        return Float(repetitions) * type.getValues(muscleFilter: muscleFilter)
    }
    
    public func toString() -> String {
        return self.type.name
            + ", " + String(self.repetitions)
            + ", " + DateUtils.toStore(date: self.date)
    }
}
