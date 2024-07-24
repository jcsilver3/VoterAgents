//
//  SimControlView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI

struct SimControlView: View {
    @ObservedObject var sim: Simulation
    @State private var runTask: Task<Void, Never>? = nil
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    Task {
                        await sim.reset()
                    }
                }, label: {
                    Text("Reset")
                })
                Button(action: {
                    runTask = Task {
                        await sim.run()
                    }
                }, label: {
                    Text("Run")
                })
                Button(action: {
                    runTask?.cancel()
                    Task {
                        sim.stop()
                    }
                }, label: {
                    Text("Stop")
                })
                HStack {
                    LabeledContent {
                        Slider(value: $sim.globals.default_sim_speed, in:1...sim.globals.default_max_sim_speed)
                        
                    } label: {
                        Text("Speed:") //\(Int(sim.globals.default_agent_speed))")
                    }.frame(minWidth: 50, maxWidth: 250)//.padding()
                }
                
            }
            HStack {
                Toggle("Metrics", isOn: $sim.globals.default_metrics_enabled)
                Toggle("ViewPort", isOn: $sim.globals.default_viewport_enabled)
                Toggle("Logging", isOn: $sim.globals.default_logging_enabled)
            }
        }
    }
}
