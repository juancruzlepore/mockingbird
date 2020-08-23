//
//  ScoresProvider.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 13/8/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class ScoresProvider: ObservableObject {
    var maxScore: Float {
        let curMaxScore = scores.values.reduce(0, {max($0, $1)})
        let curMaxNewScore = newScores?.values.reduce(0, {max($0, $1)}) ?? 0
        let curMaxReference = references?.values.reduce(0, {max($0, $1)}) ?? 0
        return [curMaxScore, curMaxNewScore, curMaxReference].max()! * 1.1
    }
    var scores: [MuscleGroup:Float] { [:] }
    var newScores: [MuscleGroup:Float]? { nil }
    var references: [MuscleGroup:Float]? { nil }
}

class FixedScoresProvider: ScoresProvider {
    override var scores: [MuscleGroup:Float] { self.fixedScores }
    
    private let fixedScores: [MuscleGroup:Float]
    
    init(scores: [MuscleGroup:Float]) {
        self.fixedScores = scores
        super.init()
    }
}

class NewSeriesScoresProvider: ScoresProvider {
    
    private let streaks = TargetHandler.defaultTarget.streaks
    private var newSeriesReps: Int? = nil
    private var newSeriesWorkout: Workout? = nil
    
    override init() {
        super.init()
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(update),
                       name: .WorkoutHistoryChanged,
                       object: nil)
        nc.addObserver(self, selector: #selector(updateSelected), name: Notification.Name.SelectedWorkoutChanged, object: nil)
        nc.addObserver(self, selector: #selector(updateReps), name: Notification.Name.NewSeriesRepsChanged, object: nil)
    }
    
    override var scores: [MuscleGroup:Float] {
        Series.flatten(scores: TargetHandler.defaultTarget.historyProviderFor(week: 0)
            .historyByDay.map({$0.scorePerMuscle}))
    }
    
    override var references: [MuscleGroup:Float]? { Settings.instance.targetV2.targetByMuscle }
    
    override var newScores: [MuscleGroup:Float]? {
        let reps: Int = (self.newSeriesReps ?? 0)
        return newSeriesWorkout?.values
            .mapValues({$0 * (Float(reps))})
            .merging(scores) {$0 + $1}
    }
    
    @objc private func update() {
        self.objectWillChange.send()
    }
    
    @objc private func updateSelected(notfication: Notification) {
        self.newSeriesWorkout = notfication.object as! Workout?
        self.objectWillChange.send()
    }
    
    @objc private func updateReps(notfication: Notification) {
        self.newSeriesReps = notfication.object as! Int?
        self.objectWillChange.send()
    }
}
