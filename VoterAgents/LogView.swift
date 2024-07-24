//
//  LogView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI

struct LogView: View {
    @ObservedObject var sim: Simulation
    var body: some View {
        //ScrollView {
            VStack {
                if sim.globals.default_logging_enabled {
                    SimControlView(sim: sim).padding()
                    SimProgressView(sim: sim).padding()
                    Text("Log:")
                    Button("Clear log", action: {
                        sim.logger.clear()
                        sim.objectWillChange.send()
                    })
                    
                    List(sim.logger.logEntries.reversed()) { logEntry in //.reversed(), id: \.id) { logEntry in
                        //HStack {
                        //Text("Hello World.")
                        Text(logEntry.date.formatted(.iso8601) + ": " + logEntry.message)
                        //}
                    }
                } else {
                    Text("Logging disabled.")
                }
           }
       // }.frame(minHeight: 100)
    }
}
