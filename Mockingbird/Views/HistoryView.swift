//
//  HistoryView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

enum ScoreComparisonType {
    case previousDay, dailyRecommendation
}

struct HistoryView: View {
    @ObservedObject var target: TargetHandler
    @State var weekBeforeCurrent: Int = 0
    
    var body: some View {
        VStack {
            WeekTextView(weekBeforeCurrent: $weekBeforeCurrent, target: target)
            
            HStack {
                Button(action: {
                    self.weekBeforeCurrent += 1
                }) {
                    Text("previous week")
                }.customCornerRadius(tl: 50, tr: 0, bl: 50, br: 0)
                Button(action: {
                    self.weekBeforeCurrent -= 1
                }) {
                    Text("next week")
                }.disabled(weekBeforeCurrent == 0)
                    .customCornerRadius(tl: 0, tr: 50, bl: 0, br: 50)
            }
            List {
                ForEach(historyProvider.historyByDay) { (day: DaySeries) in
                    HistorySingleDayView(
                        historyProvider: self.historyProvider,
                        day: day,
                        compType: .previousDay
                    )
                }
            }
        }
    }
    
    var historyProvider: HistoryProvider {
        target.historyProviderFor(week: self.weekBeforeCurrent)
    }
}

struct DayScoreView: View {
    var score: Float
    
    var body: some View {
        Text(
            String(format: "%.1f", score)
        ).bold().font(Font.largeTitle)
    }
}

struct HistorySingleDayView: View {
    var historyProvider: HistoryProvider = TargetHandler.defaultTarget.historyProvider
    var day: DaySeries
    let compType: ScoreComparisonType
    
    var body: some View {
        HStack{
            DayView(daySeries: day)
            if (DateUtils.isToday(date: day.date)) {
                if (self.compType == .previousDay){
                    TodayScoreView(
                        historyByDay: self.historyProvider.historyByDay,
                        today: day
                    ).frame(width: 80)
                } else if (self.compType == ScoreComparisonType.dailyRecommendation) {
                    VStack {
                        TodayScoreViewV2(
                            historyByDay: self.historyProvider.historyByDay,
                            today: day,
                            goal: self.todaysGoal
                        )
                        Text("days left: \(daysLeft)")
                    }.frame(width: 80)
                }
            } else {
                DayScoreView(score: day.score).frame(width: 80)
            }
            MultiMuscleScoreView(maxScore: 110, scores: day.scorePerMuscle)
        }.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 5.0))
    }
    
    var daysLeft: Int {
        TargetHandler.defaultTarget
            .daysLeftThisPeriod(includingToday: true)
    }
    
    var todaysGoal: Float {
        let thisWeekTotal = TargetHandler.defaultTarget
            .historyProviderFor(week: 0).history.reduce(0.0, {$0 + $1.score})
        let thisWeekTotalGoal = Settings.instance.targetV2.targetsSum
        let todaysScore = day.score
        let thisWeekRemaining = thisWeekTotalGoal - thisWeekTotal + todaysScore
        let daysPerWeek = 5
        let idealPerDay = thisWeekTotalGoal / Float(daysPerWeek)
        let goal = (1...daysLeft).reversed().map({thisWeekRemaining / Float($0)})
            .first(where: {$0 >= idealPerDay}) ?? thisWeekRemaining
        return goal
    }
}

struct WeekTextView: View {
    @Binding var weekBeforeCurrent: Int
    let target: TargetHandler
    
    let formatter = DateUtils.instance.dateFormatterShortDayOfWeek
    var freq: FrequencyWithCalendarPeriod {
        target.target.freq
    }
    var startDayString: String {
        let start = freq.getPeriodStartFor(week: weekBeforeCurrent)
        return formatter.string(from: start)
    }
    
    var endDayString: String {
        let end = freq.getPeriodEndFor(week: weekBeforeCurrent)
        var components = DateComponents()
        components.day = -1
        let inclusiveEnd = Calendar.current.date(byAdding: components, to: end)!
        return formatter.string(from: inclusiveEnd)
    }
    
    var dateIntervalString: String {
        "\(self.startDayString) - \(self.endDayString)"
    }
    
    var body: some View {
        VStack {
            if(weekBeforeCurrent == 0){
                Text(dateIntervalString).fontWeight(.bold).foregroundColor(Color.green)
            } else {
                Text(dateIntervalString)
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        HistoryView(target: TargetHandler(target: TestUtils.generalTarget1))
    }
}
