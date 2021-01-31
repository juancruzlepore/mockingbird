//
//  Persistence.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

protocol Persistence {
    
    func getWorkoutHistory() -> [Series]
    
    func saveWorkoutHistory(history: [Series])
    
    func loadSettings()
    
    func saveSettings()
}

extension Persistence {
    func loadDefaultSettings() {
        _ = Settings.instance.addTargetV2(target: TargetV2(targetByMuscle: [
                        .ABS: 150,
                        .ARMS: 150,
                        .BACK: 200,
                        .SHOULDERS: 100,
                        .CHEST: 150,
                        .LEGS: 100
                    ]))
    }
    
    func saveCurrentWorkoutHistory() {
        self.saveWorkoutHistory(history: WorkoutsManager.instance.getHistory())
    }
}
