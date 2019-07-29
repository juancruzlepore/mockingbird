//
//  SortedRecentSet.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 29/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class SortedRecentSet<T: Hashable> {
    
    private var elements: [T:Date]
    private let maxSize: UInt
    
    init(maxSize: UInt = 1000){
        elements = [:]
        if maxSize > 0 {
            self.maxSize = maxSize
        } else {
            self.maxSize = 1000
        }
    }
    
    func insert(elem: T){
        if (elements[elem] == nil && elements.count >= maxSize) {
            let leastUsed = elements.min { (e1, e2) -> Bool in
                            e1.value < e2.value
                        }!.key
            elements.removeValue(forKey: leastUsed)
        }
        elements[elem] = Date()
    }
    
    func getSortedList() -> [T] {
        return elements.sorted { (e1, e2) -> Bool in
            e1.value > e2.value
        }.map { $0.key }
    }
}
