//
//  WorkOut.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

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
    
//    init(line: String) {
//        let parts = line.components(separatedBy: ",")
//        self.name = parts[0].trim()
//        self.value = Float(parts[1].trim())!
//    }
}
