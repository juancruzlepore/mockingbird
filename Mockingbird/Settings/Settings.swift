//
//  Configuration.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class Settings: ObservableObject, Codable {
    
    @Published var showingView: ShowingView = .history
    @Published var showingSettings: Bool = false
    
    private static var privateInstance = Settings()
    
    static var instance: Settings {
        get {
            return Self.privateInstance
        }
        set(newValue) {
            Self.privateInstance = newValue
        }
    }
    
    private static let threeTimesAWeekFreq = FrequencyWithCalendarPeriod(period: .WEEK, timesInPeriod: 3, periodStart: DateUtils.getDate(dateString: "29-07-2019")!)
    static let defaultTarget = Target(frequency: threeTimesAWeekFreq, name: "General")
    var targetV2: TargetV2 = TargetV2(targetByMuscle: [MuscleGroup:Float]())
    
    func toggleShowSettings() {
        self.showingSettings = self.showingSettings ? false : true
    }
    
    func addTargetV2(target: TargetV2) -> Settings {
        self.targetV2 = target
        return self
    }
    
    func updateTarget(_ value: Float, forMuscle muscle: MuscleGroup){
        self.targetV2.updateTarget(value, forMuscle: muscle)
        self.objectWillChange.send()
    }
    
    func getTarget(forMuscle muscle: MuscleGroup) -> Float?{
        self.targetV2.targetByMuscle[muscle]
    }
    
    private enum CodingKeys: String, CodingKey {
        case targetV2
    }

}

@propertyWrapper struct SettingsMuscleGoal {
    let muscle: MuscleGroup
    
    var wrappedValue: String {
        get {
            String(Settings.instance.targetV2.targetByMuscle[muscle] ?? 0)
        }
        set {
            Settings.instance.targetV2.targetByMuscle[muscle] = Float(newValue) ?? 0
        }
    }
    
    init(muscle: MuscleGroup, defaultVal: String) {
        self.muscle = muscle
        self.wrappedValue = defaultVal
    }
}
