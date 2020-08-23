//
//  TestUtils.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 27/7/20.
//  Copyright © 2020 Juan Cruz Lepore. All rights reserved.
//

import Foundation

class TestUtils {
    static let series1 = Series(type: WorkoutDefinitions.getByName(name: "Back lever")!, reps: 5, date: Date())
    static let series2 = Series(type: WorkoutDefinitions.getByName(name: "Wide Push-up")!, reps: 10, date: Date())
    static let series3 = Series(type: WorkoutDefinitions.getByName(name: "Wide Pull-up")!, reps: 8, date: Date())
    
    static let seriesList1 = SeriesList(series: [
        series1,
        series2,
        series3
    ])
    
    static let today = Date()
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
    static let daySeries1 = DaySeries(date: Date())
        .addSeries(series: series1)
        .addSeries(series: series2)
        .addSeries(series: series3)
    
    static let daySeries2 = DaySeries(
        date: yesterday)
        .addSeries(series: series1)
        .addSeries(series: series2)

    static let startDateMonday = DateUtils.getDate(dateString: "29-07-2019")!
    
    static let generalTarget1: Target = Target(
        frequency: FrequencyWithCalendarPeriod(period: Period.WEEK, timesInPeriod: 3, periodStart: startDateMonday),
        name: "general")
}
