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
    
    private static func genWorkoutsMap() -> [String: Workout] {
        let map = WorkoutDefinitions.descriptions.reduce(into: [String: Workout]()) {
            $0[$1.name] = $1
        }
        os_log("Workout descriptions found: %d", map.count)
        return map
    }
    
    private init(){
        self.workoutsMap = WorkoutsManager.genWorkoutsMap()
        self.history = []
        self.frequentWorkouts = SortedRecentSet(maxSize: 10)
    }
    
//    lazy var streaks: StreaksManager = StreaksManager(historyProvider: self) // MARK: reference loop?
    var persistence: Persistence?
    var workoutsMap: [String: Workout]
    var workoutsList: [Workout] {
        ([Workout])(workoutsMap.values)
    }
    var frequentWorkouts: SortedRecentSet<Workout>
    var frequentWorkoutsList: [Workout]{
        frequentWorkouts.getSortedList()
    }
    var infrequentWorkoutsList: [Workout] {
        Array(Set(workoutsList).symmetricDifference(Set(frequentWorkoutsList)))
    }
    
    @Published var history: [Series]
    
    public func getHistory() -> [Series] {
        return self.history
    }
    
    public func setPersistence(persistence: Persistence) -> WorkoutsManager {
        self.persistence = persistence
        return self
    }
    
    private func parseSeriesLine(seriesLine: String) -> (name: String, repsString: String, dateString: String) {
        let parts = seriesLine.components(separatedBy: ",").map({ $0.trim() })
        return (parts[0], parts[1], parts[2])
    }
    
    public func update() {
        assert(persistence != nil)
        if(persistence == nil){
            return
        }
        persistence!.getWorkoutHistory().forEach { series in
            history.append(series)
        }
        
        if(frequentWorkouts.isEmpty()){
            let periodLengthToLookBack = Period.FORTNIGHT
            let lastWeekSeries = self.getHistoryByDay(from: DateUtils.today() - periodLengthToLookBack,
                to: DateUtils.tomorrow(), ignoringToday: false, orderedInc: true)
                .flatMap({$0.series.flatMap({$0.series})})
            for s in lastWeekSeries {
                frequentWorkouts.insert(elem: s.workout)
            }
        }
        return
    }
        
    public func addSeries(series: Series) {
        history.append(series)
        workoutHistoryDidChange();
        frequentWorkouts.insert(elem: series.workout)
    }
    
    private func workoutHistoryDidChange() {
        self.objectWillChange.send()
        notificationCenter.post(name: .WorkoutHistoryChanged, object: nil)
        persistence?.saveCurrentWorkoutHistory()
    }
    
    public func getWorkoutFrom(name: String) -> Workout? {
        return self.workoutsMap[name]
    }
}
