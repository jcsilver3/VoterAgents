//
//  Log.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

class Log {
    var logEntries: [LogEntry]
    
    init() {
        logEntries = [LogEntry]()
    }
    func log(message: String) {
        logEntries.append(LogEntry(date: Date.now, message: message))
    }
}

struct LogEntry {
    var date: Date
    var message: String
}
