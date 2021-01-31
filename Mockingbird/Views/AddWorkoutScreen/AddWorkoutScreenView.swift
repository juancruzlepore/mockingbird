//
//  AddWorkoutScreenView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct AddWorkoutScreenView: View {
    
    @State var selectedMuscles: [MuscleGroup] = []
    @ObservedObject var target = TargetHandler.defaultTarget
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0){
                VStack{
                    SelectMuscleBar(selectedMuscles: self.$selectedMuscles)
                    HStack {
                        WorkoutPickerView(workouts: WorkoutDefinitions.descriptions,
                                          selectedMuscles: self.$selectedMuscles)
                            .frame(width: geometry.size.width / 6)
                        VStack {
                            Text("frequent:").font(.subheadline)
                            WorkoutPickerView(workouts: UsageStats.instance.getTopNWorkouts(n: 10),
                                          selectedMuscles: self.$selectedMuscles)
                        }.frame(width: geometry.size.width / 6)
                    }
                }
                .frame(width: geometry.size.width / 3)
                VStack {
                    NewSeriesView().padding(.all, 10).environmentObject(WorkoutsManager.instance)
                    HistorySingleDayView(
                        day: self.todayDaySeries ?? DaySeries(date: Date()),
                        compType: ScoreComparisonType.dailyRecommendation
                    )
                }.frame(width: geometry.size.width / 3)
                VStack {
                    WeekTargetView()
                }.padding(.all, 10).frame(width: geometry.size.width / 3)
                
            }
        }
    }
    
    var todayDaySeries: DaySeries? {
        self.target
            .historyProvider
            .historyByDay
            .first(
                where: {
                    DateUtils.isToday(date: $0.date)
            })
    }
}

struct AddWorkoutScreenView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack{
            AddWorkoutScreenView()
        }
        
    }
}
