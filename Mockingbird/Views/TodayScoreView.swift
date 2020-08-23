//
//  SwiftUIView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

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

struct TodayScoreView_Previews: PreviewProvider {
    
    static let history: [DaySeries] = [
        TestUtils.daySeries1,
        TestUtils.daySeries2
    ]
    
    static let todaySeries = TestUtils.daySeries2
    
    static var previews: some View {
        TodayScoreView(historyByDay: history, today: todaySeries)
    }
}
