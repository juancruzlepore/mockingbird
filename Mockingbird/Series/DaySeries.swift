//
//  DaySeries.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 2/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI

final class DaySeries: Identifiable {
    private static let dateFormat = "MMM dd, yyyy"

    private let dateFormatterPrint: DateFormatter
    
    public let id: Int
    public let date: Date
    
    private var seriesMap: [WorkOut: SeriesList]
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
    
    public func addSeries(series newSeries: Series){
        seriesMap[newSeries.type] = seriesMap[newSeries.type, default: SeriesList()].addSeries(series: newSeries)
    }
}
