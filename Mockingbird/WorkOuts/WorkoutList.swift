//
//  WorkoutList.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 3/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

class WorkoutList: ObservableObject {
    @Published var workouts: [Workout]
    @Published var selected: Workout?
    @Published var workoutSelections: [(Workout, Bool, String)]
    
    init(workouts: [Workout], selected: Workout?){
        self.workouts = workouts
        self.selected = selected
        self.workoutSelections = workouts.map({($0, $0 == selected, "\($0.name)-\(String($0 == selected))")})
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateSelected), name: Notification.Name.SelectedWorkoutChanged, object: nil)
    }
    
    func setSelected(selected: Workout?){
        let nc = NotificationCenter.default
        os_log("WorkoutList setSelected")
        nc.post(name: Notification.Name.SelectedWorkoutChanged, object: selected)
    }
    
    @objc private func updateSelected(notfication: Notification) {
        self.selected = notfication.object as! Workout?
        self.workoutSelections = workouts.map({($0, $0 == self.selected, "\($0.name)-\(String($0 == self.selected))")})
        self.objectWillChange.send()
    }
    
    
}
