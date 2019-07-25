//
//  WorkOutDescriptions.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 6/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log



final class WorkOutDefinitions {
    public static let L_SIT_VAL: Float = 0.3
    public static let descriptions: [WorkOut] = [
        WorkOut(
            name: "Pull-up",
            values: [.BACK:1.0],
            movementType: .PULL
        ),
        WorkOut(
            name: "L-sit Pull-up",
            values: [
                .BACK: 1.2,
                .ABS: L_SIT_VAL
            ],
            movementType: .PULL
        ),
        WorkOut(
            name: "Wide Pull-up",
            values: [.BACK:1.2],
            movementType: .PULL
        ),
        WorkOut(
            name: "L-sit Wide Pull-up",
            values: [
                .BACK: 1.4,
                .ABS: L_SIT_VAL
            ],
            movementType: .PULL
        ),
        WorkOut(
            name: "Wide Pull-up to Chest",
            values: [.BACK:2.0],
            movementType: .PULL
        ),
        WorkOut(
            name: "Close Pull-up",
            values: [.BACK:1.35],
            movementType: .PULL
        ),
        WorkOut(
            name: "L-sit Close Pull-up",
            values: [
                .BACK: 1.55,
                .ABS: L_SIT_VAL
            ],
            movementType: .PULL
        ),
        WorkOut(
            name: "Archer Pull-up",
            values: [.BACK:1.5],
            movementType: .PULL
        ),
        WorkOut(
            name: "Push-up",
            values: [.CHEST:0.75],
            movementType: .PUSH
        ),
        WorkOut(
            name: "Wide Push-up",
            values: [.CHEST:1.1],
            movementType: .PUSH
        ),
    ]
    
    public static func getById(ID: Int) -> WorkOut? {
        os_log("workout id: %d", ID)
        for w in descriptions {
            if w.id == ID {
                return w
            }
        }
        return nil
    }
}
