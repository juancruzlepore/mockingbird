//
//  SeriesList.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class SeriesList: Combine.ObservableObject, Identifiable, SeriesGroup, Encodable, Decodable {
    var allSeries: [Series] {
        self.series
    }
        
    private static var counter: Int = 0
    private static func nextId() -> Int {
        SeriesList.counter += 1
        return SeriesList.counter
    }
    
    public let id: Int
    
    var series = [Series]() {
        didSet {
            objectWillChange.send()
        }
    }
    var totalReps: Int {
        series.reduce(0, { (r, s) -> Int in
            r + s.repetitions
        })
    }
    var totalScore: Float {
        series.reduce(0.0, { (r, s) -> Float in
            r + s.score
        })
    }
    
    public var historyByDay: [DaySeries] {
        get {
            var historyMap = [Date:DaySeries]()
            for s in series {
                if (historyMap[s.date] == nil){
                    historyMap[s.date] = DaySeries(date: s.date)
                }
                _ = historyMap[s.date]!.addSeries(series: s)
            }
            let history = [DaySeries](historyMap.values)
            return history.sorted {$0.date > $1.date}
        }
    }
    
    init(series: [Series] = []){
        self.series = series
        self.id = SeriesList.nextId()
    }
    
    public func addSeries(series newSeries: Series) -> SeriesList {
        self.series.append(newSeries)
        return self
    }
    
    enum MyStructKeys: String, CodingKey {
      case fullName = "fullName"
      case id = "id"
      case twitter = "twitter"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MyStructKeys.self)
        try container.encode(self.series, forKey: .fullName)
        
    }
}
