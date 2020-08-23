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
            Text("Streak & goal").font(Font.title)
            HStack{
                VStack{
                    PeriodStreakView(streaks: streaks)
                    CurrentPeriodView(streaks: streaks)
                    WeekImprovementView(weekOverWeekRatio: streaks.getWeekOverWeekRatio())
                }.padding(5)
                MultiMuscleScoreView(maxScore: Settings.instance.targetV2.maxTarget,
                                     scores: self.scores,
                                     references: Settings.instance.targetV2.targetByMuscle)
            }
        }
    }
    
    var scores: [MuscleGroup:Float] {
        Series.flatten(scores: streaks.historyProvider
            .getHistoryByDay(from: streaks.currentPeriodStart!,
                         to: Date(),
                         ignoringToday: false,
                         orderedInc: false).map({$0.scorePerMuscle}))
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
        VStack{
            Text(String(format: "Current streak: %d ",
                        streaks.currentStreak as Int) +
                        (streaks.currentStreak == 1 ? Period.WEEK.rawValue.singularName : Period.WEEK.rawValue.pluralName))
            if (streaks.currentPeriodStart != nil && streaks.currentPeriodEnd != nil){
                Text(DateUtils.toShowWithWeekDay(date: streaks.currentPeriodStart!)
                    + " - "
                    + DateUtils.toShowWithWeekDay(date: streaks.currentPeriodEnd! - Day(1))).foregroundColor(Color.gray)
            }
        }
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




