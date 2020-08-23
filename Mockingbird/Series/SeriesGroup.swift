//
//  SeriesGroup.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 30/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation

protocol SeriesGroup {
    var allSeries: [Series] { get }
    static func flatten(scores: [[MuscleGroup:Float]]) -> [MuscleGroup:Float]
}

extension SeriesGroup {
    var scorePerMuscle: [MuscleGroup:Float] {
        var dict = [MuscleGroup:Float]()
        for s in self.allSeries {
            for (muscle, score) in s.workout.values {
                if (dict[muscle] == nil) {
                    dict[muscle] = 0.0
                }
                dict[muscle]! += score * Float(s.repetitions)
            }
        }
        return dict
    }
    
    static func flatten(scores: [[MuscleGroup:Float]]) -> [MuscleGroup:Float] {
        var dict = [MuscleGroup:Float]()
        for s in scores {
            for (muscle, score) in s {
                if (dict[muscle] == nil) {
                    dict[muscle] = 0.0
                }
                dict[muscle]! += score
            }
        }
        return dict
    }
}
