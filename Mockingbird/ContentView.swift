//
//  ContentView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 23/6/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

enum ShowingView {
    case history, addWorkout, workoutsGallery;
}

struct ContentView : View {
    @State var selectedTarget: Int = 1
    @ObservedObject var settings: Settings = Settings.instance
    @ObservedObject var wom: WorkoutsManager = WorkoutsManager.instance
    
    var targets: [Target]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topTrailing) {
                    ControlBarView()
                    Spacer()
                }
                VStack{
                    if (settings.showingView == .history){
                        BaseView(target: TargetHandler.defaultTarget).frame(height: 600)
                    }
                    if (settings.showingView == .addWorkout) {
                        AddWorkoutScreenView()
                    }
                }
            }.blur(radius: self.settings.showingSettings ? 6.0 : 0.0)
            if (self.settings.showingSettings) {
                ZStack(alignment: .center) {
                    Spacer()
                    SettingsView()
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct BaseView: View {
    @EnvironmentObject var wom: WorkoutsManager
    @ObservedObject var target: TargetHandler
    
    var body: some View {
        HStack{
            HistoryView(target: target)
                .padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 2.0))
            VStack{
                StreaksView(streaks: target.streaks)
            }.padding(EdgeInsets(top: 0.0, leading: 1.0, bottom: 0.0, trailing: 20.0))
        }
    }
}

//#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static let wom = WorkoutsManager.instance
    
    static let twiceAWeekFreq = FrequencyWithCalendarPeriod(period: .WEEK, timesInPeriod: 2, periodStart: DateUtils.getDate(dateString: "29-07-2019")!)
    static let backTarget = Target(frequency: twiceAWeekFreq, name: "Back", muscleFilter: { $0 == MuscleGroup.BACK })
    
    static var previews: some View {
        ContentView(targets: [backTarget])
    }
}
//#endif
