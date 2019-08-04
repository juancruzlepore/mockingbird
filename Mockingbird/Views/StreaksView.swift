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
            PeriodStreakView(streaks: streaks)
            CurrentPeriodView(streaks: streaks)
            WeekImprovementView(weekOverWeekRatio: streaks.getWeekOverWeekRatio())
        }
    }
}

struct PeriodStreakView: View {
    @ObservedObject var streaks: StreaksManager
    
    var body: some View {
        HStack{
            Text("This " + streaks.freq.period.rawValue.singularName + String(format: ": %d / %d",
                streaks.timesThisPeriod as Int,
                streaks.periodTarget as Int))
            if (streaks.timesThisPeriod >= streaks.periodTarget){
                Text(" ✓").foregroundColor(Color.green)
            }
        }
    }
}

struct CurrentPeriodView: View {
    @ObservedObject var streaks: StreaksManager
    
    var body: some View {
        Text(String(format: "Current streak: %d ",
                    streaks.currentStreak as Int) +
                    (streaks.currentStreak == 1 ? Period.WEEK.rawValue.singularName : Period.WEEK.rawValue.pluralName))
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




