//
//  NewSeriesView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI
import Combine

struct NewSeriesView: View {
    @ObservedObject var newSeries: NewSeries = NewSeries.init(reps: 10)
    @EnvironmentObject var wom: WorkoutsManager
    @State var repsText: String = "10"
    
    private var buttonDisabled: Bool {
        self.newSeries.workout == nil
    }
    
    init(initialReps: Int = 10) {
        newSeries.repetitions = initialReps
        repsText = "\(initialReps)"
    }
    
    var body: some View {
        VStack {
            if(newSeries.workout != nil){
                WorkoutElementView(workout: newSeries.workout!)
            }
            TextField("reps", text: $repsText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .onReceive(Just(repsText)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.repsText = filtered
                    }
                    if(Int(self.repsText) ?? 0 > 10000) {
                        self.newSeries.repetitions = 10000
                        self.repsText = "10000"
                    } else {
                        self.newSeries.repetitions = Int(self.repsText) ?? 0
                    }
            }
            .frame(width: 60)
            .padding(.all, 5)
            SmallButton(buttonText: Text("add")).padding(.all, 5).onTapGesture {
                self.wom.addSeries(
                    series: Series(
                        type: WorkoutDefinitions.getById(
                            ID: self.newSeries.workout!.id)!,
                        reps: self.newSeries.repetitions,
                        date: DateUtils.today()
                    )
                )
            }.disabled(self.buttonDisabled)
        }
    }
    
    
}

struct NewSeriesView_Previews: PreviewProvider {
    static var previews: some View {
        NewSeriesView(initialReps: 10)
    }
}
