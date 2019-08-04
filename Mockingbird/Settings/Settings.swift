//
//  Configuration.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class Settings {
    
    static let instance = Settings()
    var targets: [Target]
    
    private init() {
        self.targets = []
    }
    
    func addTargets(targets: [Target]) -> Settings {
        self.targets.append(contentsOf: targets)
        return self
    }
    
    func addTarget(target: Target) -> Settings {
        self.targets.append(target)
        return self
    }
    
    func removeTarget(target: Target) -> Settings {
        if let toRemoveIndex = self.targets.lastIndex(where: { $0.name == target.name}) {
            self.targets.remove(at: toRemoveIndex)
        }
        return self
    }
    
    func removeAllTargets() -> Settings {
        targets = []
        return self
    }
}
