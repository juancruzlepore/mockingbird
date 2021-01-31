//
//  ControlBarView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 16/1/21.
//  Copyright © 2021 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct ControlBarView: View {
    var body: some View {
        HStack {
            ScreenSelector()
            Button(action: { Settings.instance.toggleShowSettings() }) {
                Text("Settings")
            }.padding(.all, 10)
        }
    }
}

struct ScreenSelector: View {
    
    @ObservedObject var settings = Settings.instance
    
    var body: some View {
        HStack {
            SmallButton(buttonText: Text("history"), forceDisabledStyle: self.settings.showingView != .history).onTapGesture {
                settings.showingView = .history
            }
            SmallButton(buttonText: Text("new workout"), forceDisabledStyle: self.settings.showingView != .addWorkout).onTapGesture {
                settings.showingView = .addWorkout
            }
//            SmallButton(buttonText: Text("workouts gallery"))
        }
    }
}

struct ControlBarView_Previews: PreviewProvider {
    static var previews: some View {
        ControlBarView()
    }
}
