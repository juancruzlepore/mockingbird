//
//  WorkOutsManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import os.log

class WorkOutsManager: BindableObject, HistoryProvider {
    var willChange = PassthroughSubject<Void, Never>()
    
//    typealias PublisherType = PassthroughSubject<Void, Never>
    
    public static let instance = WorkOutsManager()
    
    private enum WORKOUTS: String {
        case WIDE_PULL_UP = "Wide Pull-up"
        case CLOSE_PULL_UP = "Close Pull-up"
        case PUSH_UP = "Push-up"
    }
    
    private static func genWorkOutsMap() -> [String: WorkOut] {
        let map = WorkOutDefinitions.descriptions.reduce(into: [String: WorkOut]()) {
            $0[$1.name] = $1
        }
        os_log("Workout descriptions found: %d", map.count)
        return map
    }
    
    private init(){
        self.workOutsMap = WorkOutsManager.genWorkOutsMap()
        self.history = []
    }
    
    lazy var streaks: StreaksManager = StreaksManager(historyProvider: self) // MARK: reference loop?
    var persistence: Persistence?
    var workOutsMap: [String: WorkOut]
    var workOutsList: [WorkOut] {
        ([WorkOut])(workOutsMap.values)
    }
    var history: [Series]
    var score: Float32 {
        get {
            return history.reduce(0, {result, series in result + Float32(series.repetitions) * series.type.value})
        }
    }
    var historyByDay: [DaySeries] {
        let historyMap = self.mapByDate(map: self.history)
        let history = [DaySeries](historyMap.values)
        os_log("historyByDay entries : %d", history.count)
        return history.sorted {$0.date > $1.date}
    }
    
    public func setPersistence(persistence: Persistence) -> WorkOutsManager {
        self.persistence = persistence
        return self
    }
    
    public func update() {
        assert(persistence != nil)
        if(persistence == nil){
            return
        }
        persistence!.getWorkOutHistory().forEach { series in
            if(series==""){
                os_log("History line is nil")
                return 
            }
            let parts = series.components(separatedBy: ",").map({ $0.trim() })
            let currentWorkOut = workOutsMap[parts[0]]!
            let date = DateUtils.getDate(dateString: parts[2])
            if(date == nil){
                os_log("error parsing series date: %s", parts[2])
                return
            }
            history.append(Series(type: currentWorkOut, reps: Int(parts[1]) ?? 0, date: date!))
        }
        return
    }
    
    public func getHistoryByDay(where: (Series) -> Bool) -> [DaySeries] {
        let filteredHistory = history.filter(`where`)
        let filteredMap = self.mapByDate(map: filteredHistory)
        let days = [DaySeries](filteredMap.values)
        return days.sorted {$0.date > $1.date}
    }
    
    public func addSeries(series: Series) {
        self.persistence?.addSeriesToHistory(series: series.toString())
        self.history.append(series)
        self.willChange.send()
    }
    
    private func mapByDate(map: [Series]) -> [Date:DaySeries]{
        var historyMap = [Date:DaySeries]()
        for s in history {
            if (historyMap[s.date] == nil){
                historyMap[s.date] = DaySeries(date: s.date)
            }
            historyMap[s.date]!.addSeries(series: s)
        }
        return historyMap
    }
}
