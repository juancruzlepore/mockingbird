//
//  DayView.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import SwiftUI

struct DayView: View {
    var daySeries: DaySeries
    var zeroPadding = EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    var noSpaceList = EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    
    var body: some View {
        VStack {
            Text(daySeries.dateString)
            List {
                ForEach(daySeries.series.sorted {
                    if ($0.totalReps != $1.totalReps){
                        return $0.totalReps > $1.totalReps
                    } else {
                        return $0.series[0].workout.name < $1.series[0].workout.name
                    }
                }) { (s: SeriesList) in
                    HStack{
                        Text(String(s.totalReps)).padding(self.zeroPadding)
                        Text(String(s.series[0].workout.name)).padding(self.zeroPadding)
                    }.padding(self.noSpaceList)
                }
            }.frame(height: 60, alignment: .center)
                .foregroundColor(Color.init(red: 0.5, green: 0.5, blue: 0.5))
                .padding(
                    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
        }
    }
    
}


struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(daySeries: TestUtils.daySeries1)
    }
}
