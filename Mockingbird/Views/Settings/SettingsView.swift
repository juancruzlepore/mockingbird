//
//  SettingsView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 19/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI
import EasyStash
import os.log

struct SettingsView: View {
    
    private func grayColor(val: Double) -> Color {
        return Color(red: val, green: val, blue: val)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 10)
                            .trim()
                            .cornerRadius(10)
                .foregroundColor(grayColor(val: 0.1))
                .opacity(1.0)
            VStack {
                Text("Settings").font(.largeTitle)
                WeeklyGoalSettingsView()
                Button(action: {
                    var options = Options()
                    options.folder = "Users"
                    let storage = try! Storage(options: options)
                    do {
                        try storage.save(object: Settings.instance, forKey: "settings")
                    } catch {
                        os_log("save settings failed")
                    }
                    Settings.instance.showingSettings = false
                }){
                    Text("Save and close")
                }
            }.padding(.all, 30)
        }.frame(width: 500, height: 400)
    }
}

struct WeeklyGoalSettingsView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weekly goal").font(.title)
            ForEach(MuscleGroup.allCases, id: \.self) { muscle in
                WeeklyGoalSingleMuscleSettingsView(muscle: muscle)
            }
        }
    }
}

struct WeeklyGoalSingleMuscleSettingsView: View {
    @ObservedObject var settings: Settings = Settings.instance
    
    let muscle: MuscleGroup
    
    var body: some View {
        HStack {
            Text("\(self.muscle.rawValue)").frame(width: 70, alignment: .leading)
            TextField("", text: Binding<String>(
                get: {
                    String(Int(self.settings.getTarget(forMuscle: self.muscle) ?? 0))
            }, set: {
                self.settings.updateTarget(Float($0) ?? 0, forMuscle: self.muscle)
            }))
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
