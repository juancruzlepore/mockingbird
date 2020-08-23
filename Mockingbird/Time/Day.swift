//
//  Day.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 28/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

struct Day {
    let number: Int
    
    var seconds: Double {
        Double(number) * 24.0 * 60.0 * 60.0
    }
    
    init(_ number: Int){
        self.number = number
    }
}
