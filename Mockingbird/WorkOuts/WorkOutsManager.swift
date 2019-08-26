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
    
    let willChange = ObservableObjectPublisher()
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
        self.frequentWorkOuts = SortedRecentSet(maxSize: 10)
    }
    
//    lazy var streaks: StreaksManager = StreaksManager(historyProvider: self) // MARK: reference loop?
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
    
    @Published var history: [Series]
    
    public func getHistory() -> [Series] {
        return self.history
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
        if(frequentWorkOuts.isEmpty()){
            let periodLengthToLookBack = Period.FORTNIGHT
            let lastWeekSeries = self.getHistoryByDay(from: DateUtils.today() - periodLengthToLookBack,
                to: DateUtils.tomorrow(), ignoringToday: false, orderedInc: true)
                .flatMap({$0.series.flatMap({$0.series})})
            for s in lastWeekSeries {
                frequentWorkOuts.insert(elem: s.type)
            }
        }
        return
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
}
