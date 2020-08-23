//
//  WorkoutPickerView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI
import os.log

struct WorkoutPickerView: View {
    @ObservedObject var workouts: WorkoutList
    @Binding var selectedMuscles: [MuscleGroup]
    
    init(workouts: [Workout], selected: Workout? = nil, selectedMuscles: Binding<[MuscleGroup]>){
        self.workouts = WorkoutList(workouts: workouts, selected: selected)
        self._selectedMuscles = selectedMuscles
    }
    
    var body: some View {
        VStack {
            List (self.workouts.workoutSelections.filter(filterFunction), id: \.2) { w, _, _ in
                WorkoutElementView(workout: w,
                                   selected: self.workouts.selected != nil
                                    && self.workouts.selected!.name == w.name)
                    .onTapGesture {
                        self.workouts.setSelected(selected: w)
                }
            }
        }
    }
    
    func filterFunction(workoutElement: (Workout, Bool, String)) -> Bool {
        if(selectedMuscles.isEmpty) {
            return true
        }
        return !workoutElement.0.values.keys.filter(
            {selectedMuscles.contains($0)}).isEmpty
    }
}

struct WorkoutPickerView_Previews: PreviewProvider {
    
    @State static var selectedMuscles: [MuscleGroup] = []
    
    static var previews: some View {
        WorkoutPickerView(workouts: WorkoutDefinitions.descriptions, selected: WorkoutDefinitions.getByName(name: "Pull-up"), selectedMuscles: Self.$selectedMuscles)
    }
}
