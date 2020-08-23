//
//  TargetV2.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 30/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation

struct TargetV2: Codable {
    var targetByMuscle: [MuscleGroup:Float]
    
    mutating func updateTarget(_ value: Float, forMuscle muscle: MuscleGroup){
        self.targetByMuscle[muscle] = value
    }
    
    var averageTargetByMuscle: Float {
        targetsSum / Float(max(targetByMuscle.count, 1))
    }
    
    var targetsSum: Float {
        targetByMuscle.values.reduce(0.0, {$0 + $1})
    }
    
    var maxTarget: Float {
        targetByMuscle.reduce(0.0, {max($0, $1.value)})
    }
}
