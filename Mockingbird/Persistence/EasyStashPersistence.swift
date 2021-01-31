//
//  EasyStashPersistence.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 9/1/21.
//  Copyright © 2021 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import EasyStash
import os.log

class EasyStashPersistence: Persistence {
    
    private static let settings_key: String = "settings"
    private static let history_key: String = "history"
    
    private let storage: Storage
    
    init() {
        var options = Options()
        options.folder = "Users"
        self.storage = try! Storage(options: options)
    }
    
    func getWorkoutHistory() -> [Series] {
        if let loadedHistory = try? storage.load(forKey: Self.history_key, as: [Series].self) {
            return loadedHistory
        } else {
            return []
        }
    }
    
    func saveWorkoutHistory(history: [Series]) {
        do {
            try storage.save(object: history, forKey: Self.history_key)
        } catch {
            os_log("save history failed")
        }
    }
    
    func loadSettings() {
        if let loadedSettings = try? storage.load(forKey: Self.settings_key, as: Settings.self) {
            _ = Settings.instance.addTargetV2(target: loadedSettings.targetV2)
        } else {
            self.loadDefaultSettings()
        }
    }
    
    func saveSettings() {
        do {
            try storage.save(object: Settings.instance, forKey: Self.settings_key)
        } catch {
            os_log("save settings failed")
        }
    }
    
}
