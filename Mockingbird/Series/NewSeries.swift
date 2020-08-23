//
//  NewSeries.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

class NewSeries: ObservableObject {
    private let nc = NotificationCenter.default
    
    @Published var workout: Workout?
    var repetitions: Int = 1 {
        didSet {
            nc.post(name: Notification.Name.NewSeriesRepsChanged, object: repetitions)
        }
    }
    
    init(reps: Int){
        
        self.repetitions = reps
        os_log("NewSeries created")
        nc.addObserver(self, selector: #selector(updateSelected), name: Notification.Name.SelectedWorkoutChanged, object: nil)
    }
    
    @objc private func updateSelected(notfication: Notification) {
        self.workout = notfication.object as! Workout?
        os_log("NewSeries workout updates")
        self.objectWillChange.send()
    }
}
