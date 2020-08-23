//
//  Utils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 25/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import SwiftUI



extension NSColor {
    func brighter(amount: CGFloat = 0.25) -> NSColor {
        return changeBrightness(multiplier: 1 + amount)
    }
    
    func darker(amount: CGFloat = 0.25) -> NSColor {
        return changeBrightness(multiplier: 1 - amount)
    }
    
    private func changeBrightness(multiplier: CGFloat) -> NSColor {
        //        var hue         : CGFloat = 0
        //        var saturation  : CGFloat = 0
        //        var brightness  : CGFloat = 0
        //        var alpha       : CGFloat = 0
        
        //        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor( hue: self.hueComponent,
                        saturation: self.saturationComponent,
                        brightness: max(0.0, min(self.brightnessComponent * multiplier, 1.0)),
                        alpha: self.alphaComponent )
        //        return NSColor(calibratedHue: 0.2,
        //                       saturation: self.saturationComponent,
        //                       brightness: 0.2,
        //                       alpha: 0.5)
    }
}

class Utils {
    static func getScore(from series: [Series], after start: Date, before end: Date) -> Float {
        series.filter({$0.date >= start && $0.date < end}).reduce(0.0) { (r, s) -> Float in
            r + s.score
        }
    }
    
    static func getLastWeekScore(from series: [Series]) -> Float {
        return Utils.getScore(from: series, after: DateUtils.addWeeksToToday(amount: -1), before: DateUtils.today())
    }
    
    static func getPenultimateWeekScore(from series: [Series]) -> Float {
        return Utils.getScore(from: series, after: DateUtils.addWeeksToToday(amount: -2), before: DateUtils.addWeeksToToday(amount: -1))
    }
    
    static func mapByDate(series: [Series]) -> [Date:DaySeries]{
        var historyMap = [Date:DaySeries]()
        for s in series {
            if (historyMap[s.date] == nil){
                historyMap[s.date] = DaySeries(date: s.date)
            }
            historyMap[s.date]!.addSeries(series: s)
        }
        return historyMap
    }
    
    static func getTopMuscle(workout: Workout) -> MuscleGroup {
        return workout.values.keys.first!
    }
    
    static func getImageForMuscle(muscle: MuscleGroup) -> Image {
        switch muscle {
        case .ABS:
            return Image("upper-front-ab")
        case .BACK:
            return Image("upper-back")
        case .CHEST:
            return Image("upper-front-ch")
        case .SHOULDERS:
            return Image("upper-front-sh")
        case .ARMS:
            return Image("arm")
        case .LEGS:
            return Image("leg")
        }
    }
    
    static func getColorForMuscle(muscle: MuscleGroup) -> NSColor {
        switch muscle {
        case .ABS:
            return NSColor.green.darker()
        case .BACK:
            return NSColor.blue.darker()
        case .CHEST:
            return NSColor.green.darker()
        case .SHOULDERS:
            return NSColor.green.darker()
        case .ARMS:
            return NSColor.red.darker()
        default:
            return NSColor.cyan.darker()
        }
    }
}

extension Notification.Name {
    static let SelectedWorkoutChanged = Notification.Name("SelectedWorkoutChanged")
    static let NewSeriesRepsChanged = Notification.Name("NewSeriesRepsChanged")
    static var WorkoutHistoryChanged = Notification.Name("WorkoutHistoryChanged")
}
