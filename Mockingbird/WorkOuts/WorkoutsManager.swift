//
//  WorkOutsManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI
import os.log

class WorkoutsManager: ObservableObject, HistoryProvider {
    
    let notificationCenter = NotificationCenter.default
        
    public static let instance = WorkoutsManager()
    
    private static func genWorkOutsMap() -> [String: Workout] {
        let map = WorkoutDefinitions.descriptions.reduce(into: [String: Workout]()) {
            $0[$1.name] = $1
        }
        os_log("Workout descriptions found: %d", map.count)
        return map
    }
    
    private init(){
        self.workOutsMap = WorkoutsManager.genWorkOutsMap()
        self.history = []
        self.frequentWorkOuts = SortedRecentSet(maxSize: 10)
    }
    
//    lazy var streaks: StreaksManager = StreaksManager(historyProvider: self) // MARK: reference loop?
    var persistence: Persistence?
    var workOutsMap: [String: Workout]
    var workOutsList: [Workout] {
        ([Workout])(workOutsMap.values)
    }
    var frequentWorkOuts: SortedRecentSet<Workout>
    var frequentWorkOutsList: [Workout]{
        frequentWorkOuts.getSortedList()
    }
    var infrequentWorkOutsList: [Workout] {
        Array(Set(workOutsList).symmetricDifference(Set(frequentWorkOutsList)))
    }
    
    @Published var history: [Series]
    
    public func getHistory() -> [Series] {
        return self.history
    }
    
    public func setPersistence(persistence: Persistence) -> WorkoutsManager {
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
                frequentWorkOuts.insert(elem: s.workout)
            }
        }
        return
    }
        
    public func addSeries(series: Series) {
        persistence?.addSeriesToHistory(series: series.toString())
        history.append(series)
        workoutHistoryDidChange();
        frequentWorkOuts.insert(elem: series.workout)
    }
    
    private func workoutHistoryDidChange() {
        self.objectWillChange.send()
        notificationCenter.post(name: .WorkoutHistoryChanged, object: nil)
    }
}
