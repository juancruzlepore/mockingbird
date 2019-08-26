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
    public static let L_SIT_VAL_IN_PULLUP: Float = 0.3
    public static let descriptions: [WorkOut] = [
        newPullWorkout(
            name: "Pull-up",
            values: [.BACK:1.0]
        ),
        newPullWorkout(
            name: "L-sit Pull-up",
            values: [
                .BACK: 1.2,
                .ABS: L_SIT_VAL_IN_PULLUP
            ]
        ),
        newPullWorkout(
            name: "Wide Pull-up",
            values: [.BACK:1.2]
        ),
        newPullWorkout(
            name: "L-sit Wide Pull-up",
            values: [
                .BACK: 1.4,
                .ABS: L_SIT_VAL_IN_PULLUP
            ]
        ),
        newPullWorkout(
            name: "Wide Pull-up to Chest",
            values: [.BACK:2.0]
        ),
        newPullWorkout(
            name: "Close Pull-up",
            values: [.BACK:1.35]
        ),
        newPullWorkout(
            name: "L-sit Close Pull-up",
            values: [
                .BACK: 1.55,
                .ABS: L_SIT_VAL_IN_PULLUP
            ]
        ),
        newPullWorkout(
            name: "Archer Pull-up",
            values: [.BACK:1.5]
        ),
        newPushWorkout(
            name: "Push-up",
            values: [.CHEST:0.75]
        ),
        newPushWorkout(
            name: "Wide Push-up",
            values: [
                .CHEST:1.1,
                .SHOULDERS:0.3
            ]
        ),
        WorkOut(
            name: "Crunch",
            values: [.ABS:0.4],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Cross Crunch",
            values: [.ABS:0.7],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Half HLL",
            values: [.ABS:1.3],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Legs Lift",
            values: [.ABS:1.0],
            movementType: .OTHER
        ),
        WorkOut(
            name: "HLL",
            values: [.ABS:2.0],
            movementType: .OTHER
        ),
        WorkOut(
            name: "HLL V to L",
            values: [.ABS:3.0],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Wall handstand RLL",
            values: [.ABS:1.5], // FIXME: dont remember and just ate :(
            movementType: .OTHER
        ),
        WorkOut(
            name: "Back lever",
            values: [.ABS:1.0], // per second?
            movementType: .ISOMETRIC
        ),
        WorkOut(
            name: "Front lever",
            values: [.ABS:2.4],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Tuck V-up",
            values: [.ABS:1.1],
            movementType: .OTHER
        ),
        WorkOut(
            name: "Straddle V-up",
            values: [.ABS:1.5],
            movementType: .OTHER
        ),
        WorkOut(
            name: "V-up",
            values: [.ABS:1.8],
            movementType: .OTHER
        ),
        newPushWorkout(
            name: "Archer Push-up",
            values: [.CHEST:1.6]
        ),
        newPushWorkout(
            name: "Shoulder Push-up",
            values: [.SHOULDERS:1.4]
        ),
        newPushWorkout(
            name: "Elevated Shoulder Push-up",
            values: [.SHOULDERS:1.7]
        ),
        newPushWorkout(
            name: "Hindu Push-up",
            values: [
                .SHOULDERS:2.2,
                .CHEST:1.4
            ]
        ),
    ]
    
    private static func newPullWorkout(name: String, values: [MuscleGroup:Float]) -> WorkOut {
        return WorkOut(name: name, values: values, movementType: .PULL)
    }
    
    private static func newPushWorkout(name: String, values: [MuscleGroup:Float]) -> WorkOut {
        return WorkOut(name: name, values: values, movementType: .PUSH)
    }
    
    private static func newOtherWorkout(name: String, values: [MuscleGroup:Float]) -> WorkOut {
        return WorkOut(name: name, values: values, movementType: .OTHER)
    }
    
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
