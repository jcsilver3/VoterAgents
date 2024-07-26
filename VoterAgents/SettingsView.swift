//
//  Config.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var sim: Simulation
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                LabeledContent {
                    TextField("m0", value: $sim.globals.default_graph_m0, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth:100)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Graph m0:")
                        .frame(alignment: .leading)
                }
            }
            HStack {
                LabeledContent {
                    TextField("NumAgents", value: $sim.globals.default_agent_count, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth:100)
                        .multilineTextAlignment(.trailing)
                } label: {
                    Text("Number of Agents:")
                        .frame(alignment: .leading)
                }
            }
            HStack {
                LabeledContent {
                    TextField("MaxAge", value: $sim.globals.default_max_age, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.trailing)
                    
                } label: {
                    Text("Max Age:").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            HStack {
                LabeledContent {
                    TextField("Flutter < p (0.00)", value: $sim.globals.default_flutter_lt, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.trailing)
                    
                } label: {
                    Text("Flutter < p (0.00)").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            HStack {
                LabeledContent {
                    TextField("Num Liars", value: $sim.globals.default_liar_count, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.trailing)
                    
                } label: {
                    Text("Num Liars:").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            HStack {
                LabeledContent {
                    TextField("Liar Eigenvalue >= x", value: $sim.globals.default_liar_gt_eigenvalue, format:.number)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.trailing)
                    
                } label: {
                    Text("Num Eigenvalue >= x").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            HStack {    LabeledContent {
                TextField("Lying frequency >= p (0.00)", value: $sim.globals.default_liar_gt_frequency, format:.number)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.trailing)
                
            } label: {
                Text("Lying frequency >= p (0.00):").frame(alignment: .leading)
            }.frame(minWidth: 50)
            }
            HStack {
                LabeledContent {
                    TextField("NumSteps", value: $sim.globals.default_step_count, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 100)
                        .multilineTextAlignment(.trailing)
                    
                } label: {
                    Text("Number of Steps:").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            
            Spacer()
            Spacer()
            VStack {
                HStack {
                    LabeledContent {
                        Slider(value: $sim.globals.default_sim_speed, in:1...sim.globals.default_max_sim_speed)
                        
                    } label: {
                        Text("Speed:") //\(Int(sim.globals.default_agent_speed))")
                    }.frame(minWidth: 50, maxWidth: 250)//.padding()
                }
                Spacer()
                Spacer()
                HStack {
                    Toggle("Metrics", isOn: $sim.globals.default_metrics_enabled)
                        .onChange(of: sim.globals.default_metrics_enabled) {
                            sim.objectWillChange.send()
                        }
                    Toggle("ViewPort", isOn: $sim.globals.default_viewport_enabled)
                        .onChange(of: sim.globals.default_viewport_enabled) {
                            sim.objectWillChange.send()
                        }
                    Toggle("Logging", isOn: $sim.globals.default_logging_enabled)
                        .onChange(of: sim.globals.default_logging_enabled) {
                            sim.objectWillChange.send()
                        }
                }
            }
        }
    }
}
    

