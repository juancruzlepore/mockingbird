//
//  TargetHandler.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import Combine

class TargetHandler: ObservableObject {
    let willChange = ObservableObjectPublisher()
    @Published var version: Int
    
    let target: Target
    let historyProvider: HistoryProvider
    let streaks: StreaksManager

    init(target: Target){
        self.target = target
        let newHistoryProvider = FilteredHistoryProvider(filter: target.workoutFilter)
        self.historyProvider = newHistoryProvider
        self.streaks = StreaksManager(historyProvider: newHistoryProvider, frequency: target.freq)
        self.version = 0
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(update),
            name: .WorkoutHistoryChanged,
            object: nil
        )
    }
    
    @objc private func update() {
        self.version += 1
    }
}
