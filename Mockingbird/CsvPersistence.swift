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

class CsvPersistence: Persistence {
    
    let workOutHistoryFile = getDocumentsDirectory().appendingPathComponent("workouts.txt")
    let workOutsDescriptionsFile = getDocumentsDirectory().appendingPathComponent("workoutsDescriptions.txt")
    
//    func getWorkOutsDescriptions() -> [WorkOut] {
//        do {
//            let history = try String(contentsOf: workOutHistoryFile)
//            let lines = history.components(separatedBy: "\n")
//            var workOutsList: [WorkOut] = []
//            lines.forEach {
//                workOutsList.append(WorkOut(line: $0))
//            }
//            return workOutsList
//        } catch {
//            os_log("Error: %s", error.localizedDescription)
//            os_log("Error reading workouts descriptions.")
//            return []
//        }
//    }
    
    func getWorkOutHistory() -> [String] {
        do {
            let history = try String(contentsOf: workOutHistoryFile)
            os_log("Workout history found")
            let lines = history.components(separatedBy: "\n")
            os_log("Workout history size: %d", lines.count)
            return lines
        } catch {
            os_log("Error: %s", error.localizedDescription)
            os_log("File path: %s", workOutHistoryFile.absoluteString)
            os_log("Error reading workout history.")
            return []
        }
    }
    
    func addSeriesToHistory(series: String) {
        let line = "\n" + series
        do {
            try line.appendToURL(fileURL: self.workOutHistoryFile)
        } catch {
            os_log("Write failed to %s.", workOutHistoryFile.absoluteString)
        }
        
    }
    
    func testWrite() -> Bool {
        let str = "Super long string here"
        do {
            try str.write(to: workOutHistoryFile, atomically: true, encoding: String.Encoding.utf8)
            os_log("Write succeded to %s.", workOutHistoryFile.absoluteString)
            return true
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            os_log("Write failed to %s.", workOutHistoryFile.absoluteString)
            return false
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        return paths[0]
    }
}
