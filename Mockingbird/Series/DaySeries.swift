//
//  DaySeries.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

final class DaySeries: Identifiable, SeriesGroup {
    var allSeries: [Series] {
        self.series.flatMap({ $0.allSeries })
    }
    
    private static let dateFormat = "MMM dd, yyyy"

    private let dateFormatterPrint: DateFormatter
    
    public let id: Int
    public let date: Date
    
    private var seriesMap: [Workout: SeriesList]
    public var series: [SeriesList] {
        get {
            ([SeriesList])(seriesMap.values)
        }
    }
    
    public var dateString: String {
        return dateFormatterPrint.string(from: date)
    }
    public var repetitions: Int {
        series.reduce(0, { (r, s) -> Int in
            r + s.totalReps
        })
    }
    public var score: Float {
        series.reduce(0.0, { (r, s) -> Float in
            r + s.totalScore
        })
    }
    
    init(date: Date){
        self.seriesMap = [:]
        self.date = date
        self.id = date.hashValue
        
        self.dateFormatterPrint = DateFormatter()
        self.dateFormatterPrint.dateFormat = DaySeries.dateFormat
    }
    
    public func addSeries(series newSeries: Series) -> DaySeries {
        seriesMap[newSeries.workout] = seriesMap[newSeries.workout, default: SeriesList()].addSeries(series: newSeries)
        return self
    }
}
