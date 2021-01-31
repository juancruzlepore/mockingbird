//
//  MovementType.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 4/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

enum MovementType: String, Codable {
    case PUSH = "Push"
    case PULL = "Pull"
    case ISOMETRIC = "Isometric"
    case OTHER = "Other" // crunches?
}
