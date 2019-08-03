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

class WorkOutsManager: Combine.ObservableObject, HistoryProvider {
    
    var willChange = PassthroughSubject<Void, Never>()
    let notificationCenter = NotificationCenter.default
        
    public static let instance = WorkOutsManager()
    
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
        self.frequentWorkOuts = SortedRecentSet(maxSize: 5)
    }
    
    lazy var streaks: StreaksManager = StreaksManager(historyProvider: self) // MARK: reference loop?
    var persistence: Persistence?
    var workOutsMap: [String: WorkOut]
    var workOutsList: [WorkOut] {
        ([WorkOut])(workOutsMap.values)
    }
    var frequentWorkOuts: SortedRecentSet<WorkOut>
    var frequentWorkOutsList: [WorkOut]{
        frequentWorkOuts.getSortedList()
    }
    var infrequentWorkOutsList: [WorkOut] {
        Array(Set(workOutsList).symmetricDifference(Set(frequentWorkOutsList)))
    }
    var history: [Series]

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
    
    public func getHistoryByDay(from start: Date, to end: Date, ignoringToday: Bool = false, orderedInc: Bool = true) -> [DaySeries] {
        let today = DateUtils.today()
        let daysOrederedDec = self.historyByDay.filter { $0.date >= start && $0.date < end && (!ignoringToday || $0.date != today) }
        if orderedInc {
            return daysOrederedDec.reversed()
        }
        return daysOrederedDec
    }
        
    public func addSeries(series: Series) {
        persistence?.addSeriesToHistory(series: series.toString())
        history.append(series)
        workoutHistoryDidChange();
        frequentWorkOuts.insert(elem: series.type)
    }
    
    private func workoutHistoryDidChange() {
        willChange.send()
        notificationCenter.post(name: .WorkoutHistoryChanged, object: nil)
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
