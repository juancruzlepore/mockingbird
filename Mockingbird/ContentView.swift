//
//  ContentView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 23/6/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObjectBinding var wom: WorkOutsManager
    
    func today() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    var body: some View {
        
        HStack{
            List {
                ForEach(wom.historyByDay) { (day: DaySeries) in
                    HStack{
                        DayView(daySeries: day)
                        if (day.date == self.today()) {
                            TodayScoreView(historyByDay: self.wom.historyByDay, today: day)
                        } else {
                            Text(String(format: "%.1f", day.score)).bold().font(Font.largeTitle)
                        }
                    }.padding(EdgeInsets(top: CGFloat(0.0), leading: CGFloat(-30.0), bottom: CGFloat(0.0), trailing: CGFloat(5.0)))
                }
            }.padding(EdgeInsets(top: CGFloat(0.0), leading: CGFloat(1.0), bottom: CGFloat(0.0), trailing: CGFloat(2.0)))
            VStack{
                StreaksView(streaks: wom.streaks)
                if (self.wom.historyByDay.count == 0) {
                    AddSeriesView(mostRecentDay: nil, wom: wom)
                } else {
                    AddSeriesView(mostRecentDay: self.wom.historyByDay[0], wom: wom)
                }
            }.padding(EdgeInsets(top: CGFloat(0.0), leading: CGFloat(1.0), bottom: CGFloat(0.0), trailing: CGFloat(20.0)))
        }
    }
}

struct DayView: View {
    var daySeries: DaySeries
    var zeroPadding = EdgeInsets(top: CGFloat(0.0), leading: CGFloat(0.0), bottom: CGFloat(0.0), trailing: CGFloat(0.0))
    var noSpaceList = EdgeInsets(top: CGFloat(-8.0), leading: CGFloat(0.0), bottom: CGFloat(0.0), trailing: CGFloat(0.0))
    var body: some View {
        VStack {
            Text(daySeries.dateString)
            List {
                ForEach(daySeries.series.sorted {
                    if ($0.totalReps != $1.totalReps){
                        return $0.totalReps > $1.totalReps
                    } else {
                        return $0.series[0].type.name < $1.series[0].type.name
                    }
                    }) { (s: SeriesList) in
                    HStack{
                        Text(String(s.totalReps)).padding(self.zeroPadding)
                        Text(String(s.series[0].type.name)).padding(self.zeroPadding)
                    }.padding(self.noSpaceList)
                }
            }.frame(width: 250, height: 60, alignment: .center).foregroundColor(Color.init(red: 0.5, green: 0.5, blue: 0.5))
                .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 2))
        }
    }
}

struct TodayScoreView: View {
    let historyByDay: [DaySeries]
    let today: DaySeries
    
    var body: some View {
        VStack {
            if historyByDay.count > 1 {
                if (historyByDay[1].score >= today.score) {
                    Text(String(format: "%.1f ▾", today.score)).bold().font(Font.largeTitle).foregroundColor(Color.red)
                } else {
                    Text(String(format: "%.1f ▴", today.score)).bold().font(Font.largeTitle).foregroundColor(Color.green)
                }
            } else {
                    Text(String(format: "%.1f", today.score)).bold().font(Font.largeTitle)
            }
        }
    }
}

struct AddSeriesView: View {
    static let smallPaddingVal: CGFloat = 5.0
    static let repsDefault: Int = 10

    let mostRecentDay: DaySeries?

    var smallPadding = EdgeInsets(top: smallPaddingVal, leading: smallPaddingVal, bottom: smallPaddingVal, trailing: smallPaddingVal)

    @State var reps = repsDefault
    @State var selectedWorkout = 1
    @State var lastRepsAdded: Int? = nil
    @ObjectBinding var wom: WorkOutsManager
    
    private func addToReps(amount: Int){
        self.reps = max(1, self.reps + amount)
    }

    var body: some View {
        VStack{
            Text("Add workout").font(Font.title)
            Picker(selection: $selectedWorkout, label: Text("Workout")) {
                ForEach(self.wom.workOutsList) { (w: WorkOut) in
                    Text(w.name).tag(w.id)
                }
            }
            HStack {
                Text(String(format: "Repetitions: %d", self.reps as Int))
                Button(action: { self.addToReps(amount: 1) }) {
                    Text("+1")
                }
                Button(action: { self.addToReps(amount: -1) }) {
                    Text("-1")
                }
                Button(action: { self.addToReps(amount: 10) }) {
                    Text("+10")
                }
                Button(action: { self.addToReps(amount: -10) }) {
                    Text("-10")
                }
                if (self.lastRepsAdded != nil && self.lastRepsAdded != 10) {
                    Button(action: { self.reps = self.lastRepsAdded! }) {
                        Text(String(format: "✧ set to %d", self.lastRepsAdded!))
                    }.background(Color(red: 0.4, green: 0.0, blue: 0.3))
                }
            }
            Button(action: {
                self.wom.addSeries(series: Series(type: WorkOutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()))
                self.lastRepsAdded = self.reps
                self.reps = AddSeriesView.repsDefault
            }) {
                if (self.mostRecentDay != nil && self.mostRecentDay!.date == DateUtils.today()){
                    Text(String(format: " Add (today → %.1f) ", mostRecentDay!.score + Series(type: WorkOutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()).score))
                } else {
                    Text(String(format: " Add (today → %.1f) ", Series(type: WorkOutDefinitions.getById(ID: self.selectedWorkout)!, reps: self.reps, date: DateUtils.today()).score))
                }
                
            }
        }.padding(smallPadding)
    }
}


struct StreaksView: View {
    let streaks: StreaksManager
    
    var body: some View {
        VStack{
            Text("Streak").font(Font.title)
            Text(String(format: "Current streak: %d", streaks.getCurrentStreak()))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(wom: WorkOutsManager.instance)
    }
}
#endif
