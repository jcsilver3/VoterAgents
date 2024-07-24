//
//  Log.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

class Logger: ObservableObject {
    var logEntries: [LogEntry]
    
    init() {
        logEntries = [LogEntry]()
    }
    func log(message: String) {
        logEntries.append(LogEntry(date: Date.now, message: message))
    }
    func clear() {
        logEntries.removeAll()
        logEntries.append(LogEntry(message:"Log cleared."))
    }
}

struct LogEntry: Identifiable {
    var id = UUID()
    var date: Date = Date.now
    var message: String
}
