//
//  AddSeriesView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 29/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct AddSeriesView: View {
    static let smallPaddingVal: CGFloat = 5.0
    static let repsDefault: Int = 10

    let mostRecentDay: DaySeries?

    var smallPadding = EdgeInsets(top: smallPaddingVal, leading: smallPaddingVal, bottom: smallPaddingVal, trailing: smallPaddingVal)

    @State var reps = repsDefault
    @State var selectedWorkout = 1
    @State var lastRepsAdded: Int? = nil
    @ObservedObject var wom: WorkoutsManager
    @ObservedObject var target: TargetHandler
    
    private func addToReps(amount: Int){
        self.reps = max(1, self.reps + amount)
    }

    var body: some View {
        VStack{
            Text("Add workout").font(Font.title)
            Picker(selection: $selectedWorkout, label: Text("Workout")) {
                ForEach(self.wom.frequentWorkOutsList.filter({target.workouts.contains($0)})) { (w: Workout) in
                    Text(w.name).tag(w.id)
                }
                if(!self.wom.frequentWorkOutsList.isEmpty){
                    Text("--separator--").disabled(true)
                }
                ForEach(self.wom.infrequentWorkOutsList.filter({target.workouts.contains($0)})) { (w: Workout) in
                    Text(w.name).tag(w.id)
                }
            }
            HStack {
                Text(String(format: "Repetitions: %d", self.reps as Int))
                Button(action: { self.addToReps(amount: 1) }) {
                    Text("+1")
                }
                Button(action: { self.addToReps(amount: -1) }) {
                    Text("-1")
                }
                Button(action: { self.addToReps(amount: 10) }) {
                    Text("+10")
                }
                Button(action: { self.addToReps(amount: -10) }) {
                    Text("-10")
                }
                if (self.lastRepsAdded != nil && self.lastRepsAdded != 10) {
                    Button(action: { self.reps = self.lastRepsAdded! }) {
                        Text(String(format: "✧ set to %d", self.lastRepsAdded!))
                    }.background(Color(red: 0.4, green: 0.0, blue: 0.3))
                }
            }
            Button(action: {
                self.wom.addSeries(series: Series(type: WorkoutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()))
                self.lastRepsAdded = self.reps
                self.reps = AddSeriesView.repsDefault
            }) {
                if (self.mostRecentDay != nil && self.mostRecentDay!.date == DateUtils.today()){
                    Text(String(format: " Add (today → %.1f) ", mostRecentDay!.score + FilteredSeries(
                        base: Series(type: WorkoutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()),
                        filter: target.target.muscleFilter
                    ).score))
                } else {
                    Text(String(format: " Add (today → %.1f) ", FilteredSeries(
                        base: Series(type: WorkoutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()),
                        filter: target.target.muscleFilter
                    ).score))
                }
                
            }
        }.padding(smallPadding)
    }
}
