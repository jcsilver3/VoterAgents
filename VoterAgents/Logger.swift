//
//  Logger.swift
//  VoterAgents
//  This file is part of the VoterAgents program, an Agent Based Model (ABM) simulation of misinformation perception.
//  Copyright (C) 2024 John Silver (jcsilver3@gmail.com, jsilver9@gmu.edu)
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
import Foundation

class Logger: ObservableObject {
    var logEntries: [LogEntry]
    
    init() {
        logEntries = [LogEntry]()
    }
    func log(message: String) {
        logEntries.append(LogEntry(date: Date.now, message: message))
        self.objectWillChange.send()
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
