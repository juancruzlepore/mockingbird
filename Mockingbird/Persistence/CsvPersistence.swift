//
//  CsvPersistence.swift
//  Mockingbird
//
//  Created by Juan Cruz Lepore on 1/7/19.
//  Copyright © 2019 Juan Cruz Lepore. All rights reserved.
//

import Foundation
import os.log

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}

class CsvPersistence {

    let workoutHistoryFile = getDocumentsDirectory().appendingPathComponent("workouts.txt")
    let workoutsDescriptionsFile = getDocumentsDirectory().appendingPathComponent("workoutsDescriptions.txt")
        
    
    init() {
        let fileExists: Bool = self.fileExists(path: workoutHistoryFile.path)
        if(!fileExists){
            let creationSuccess: Bool =
                FileManager.default.createFile(atPath: workoutHistoryFile.path, contents: nil)
            os_log("File not found, but created %d", creationSuccess)
        }
    }
    
    private func parseSeriesLine(seriesLine: String) -> (name: String, repsString: String, dateString: String) {
        let parts = seriesLine.components(separatedBy: ",").map({ $0.trim() })
        return (parts[0], parts[1], parts[2])
    }
    
    func getWorkoutHistory() -> [Series] {
        do {
            let history = try String(contentsOf: workoutHistoryFile)
            os_log("Workout history found")
            let lines = history.components(separatedBy: "\n")
            os_log("Workout history contains %d lines", lines.count)
            os_log("Workout history size: %d", lines.count)
            
            var series = [Series]()
            lines.forEach { seriesLine in
                if(seriesLine==""){
                    os_log("History line is nil")
                    return
                }
                let (name, repsString, dateString) = parseSeriesLine(seriesLine: seriesLine)
                let currentWorkout = WorkoutsManager.instance.workoutsMap[name]!
                let date = DateUtils.getDate(dateString: dateString)
                if(date == nil){
                    os_log("error parsing series date: %s", dateString)
                    return
                }
                series.append(Series(type: currentWorkout, reps: Int(repsString) ?? 0, date: date!))
            }
            return series
        } catch {
            os_log("Error: %s", error.localizedDescription)
            os_log("File path: %s", workoutHistoryFile.absoluteString)
            os_log("Error reading workout history.")
            return []
        }
    }
    
    func addSeriesToHistory(series: String) {
        let line = series + "\n"
        do {
            try line.appendToURL(fileURL: self.workoutHistoryFile)
        } catch {
            os_log("Write failed to %s.", workoutHistoryFile.absoluteString)
        }
        
    }
    
    func testWrite() -> Bool {
        let str = "Super long string here"
        do {
            try str.write(to: workoutHistoryFile, atomically: true, encoding: String.Encoding.utf8)
            os_log("Write succeded to %s.", workoutHistoryFile.absoluteString)
            return true
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            os_log("Write failed to %s.", workoutHistoryFile.absoluteString)
            return false
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return paths[0]
    }
    
    private func fileExists(path: String) -> Bool{
        return FileManager.default.fileExists(atPath: path)
    }
}
