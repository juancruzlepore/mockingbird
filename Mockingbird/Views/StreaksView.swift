//
//  StreaksView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct StreaksView: View {
    let streaks: StreaksManager
    
    var body: some View {
        VStack{
            Text("Streak").font(Font.title)
            DaysStreakView(streaks: streaks)
            WeekImprovementView(weekOverWeekRatio: streaks.getWeekOverWeekRatio())
        }
    }
}

struct DaysStreakView: View {
    let streaks: StreaksManager
    
    var body: some View {
        Text(String(format: "Current streak: %d", streaks.getCurrentStreak()))
    }
}

struct WeekImprovementView: View {
    let weekOverWeekRatio: Float?
    
    var body: some View {
        HStack{
            if (weekOverWeekRatio != nil){
                Text(String("Week over week difference: "))
                if(weekOverWeekRatio! < 1) {
                    Text(String(format: "%.1f%% ▾", (1 - weekOverWeekRatio!) * 100)).foregroundColor(Color.red)
                } else if (weekOverWeekRatio! > 1) {
                    Text(String(format: "%.1f%% ▴", (weekOverWeekRatio! - 1) * 100)).foregroundColor(Color.green)
                } else {
                    Text(String("0.0%"))
                }
                
            }
        }
    }
}




