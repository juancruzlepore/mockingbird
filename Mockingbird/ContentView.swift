//
//  ContentView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 23/6/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObservedObject var wom: WorkOutsManager
    
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

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(wom: WorkOutsManager.instance)
    }
}
#endif
