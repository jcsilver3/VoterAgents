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
        if sim.globals.default_logging_enabled {
            VStack {
                SimControlView(sim: sim)
                Spacer()
                Text("Log:")
                
                Button("Clear log", action: {
                    sim.logger.clear()
                    sim.objectWillChange.send()
                })
                
                List(sim.logger.logEntries, id: \.id) { logEntry in

                    Text("Log entry")
                }

            }
        } else {
            Text("Logging disabled.")
        }
    }
}
