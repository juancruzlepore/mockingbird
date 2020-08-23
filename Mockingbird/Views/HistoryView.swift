//
//  HistoryView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

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
                        day: day
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
    
    var body: some View {
        HStack{
            DayView(daySeries: day)
            if (day.date == DateUtils.today()) {
                TodayScoreView(
                    historyByDay: self.historyProvider.historyByDay,
                    today: day
                ).frame(width: 80)
            } else {
                DayScoreView(score: day.score).frame(width: 80)
            }
            MultiMuscleScoreView(maxScore: 110, scores: day.scorePerMuscle)
        }.padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 5.0))
    }
}

struct WeekTextView: View {
    @Binding var weekBeforeCurrent: Int
    let target: TargetHandler
    
    let formatter = DateUtils.instance.dateFormatterShortDayOfWeek
    var freq: FrequencyWithCalendarPeriod {
        target.target.freq as! FrequencyWithCalendarPeriod
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
