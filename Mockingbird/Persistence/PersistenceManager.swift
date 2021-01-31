//
//  PersistenceManager.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 9/1/21.
//  Copyright © 2021 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class PersistenceManager {
    private static var handler: Persistence? = nil
    
    public static func getHandler() -> Persistence {
        return self.handler!
    }
    
    public static func setHandler(handler: Persistence) {
        self.handler = handler
    }
}
