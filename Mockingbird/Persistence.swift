//
//  Persistence.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

protocol Persistence {
    func getWorkOutHistory() -> [String]
//    func getWorkOutsDescriptions() -> [WorkOut]
    func addSeriesToHistory(series: String)
}
