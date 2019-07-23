//
//  SingleWorkoutSeriesList.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class SingleWorkOutSeriesList: SeriesList {
    let workOut: WorkOut
    
    init(workOut: WorkOut, series: [Series] = []){
        self.workOut = workOut
        super.init()
        self.series = ([Series])(series.filter({$0.type == workOut}))
    }

    public override func addSeries(series newSeries: Series) -> SeriesList {
        if (newSeries.type == self.workOut){
            self.series.append(newSeries)
        }
        return self
    }
}
