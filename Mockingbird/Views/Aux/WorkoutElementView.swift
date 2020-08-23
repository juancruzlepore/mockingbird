//
//  WorkoutElementView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI
import os.log

struct WorkoutElementView: View {
    let workout: Workout
    let iconSize: CGFloat = 25
    @State var selected: Bool = false
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            Spacer(minLength: 10)
            Text("\(workout.name)").padding(.horizontal, 10)
            HStack{
                ForEach(workout.values.sorted(by: {$0.1 > $1.1 }),
                        id: \.0) { muscle, value in
                            HStack{
                                Utils.getImageForMuscle(muscle: muscle)
                                    .resizable()
                                    .frame(height: self.iconSize)
                                    .frame(width: self.iconSize)
                                Text(String(format: "%.1f", value))
                            }
                }
            }.padding(.horizontal, 10)
            Spacer(minLength: 10)
        }.frame(minWidth: 340, maxWidth: .infinity, alignment: .leading)
            .frame(height: 60).background(self.selected
                ? Color(.sRGBLinear, white: 0.05, opacity: 1.0)
                : Color(.sRGBLinear, white: 0.02, opacity: 1.0))
    }
}

struct WorkoutElementView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutElementView(
            workout: WorkoutDefinitions.getByName(name: "L-sit Pull-up")!)
    }
}
