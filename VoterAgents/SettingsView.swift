//
//  Config.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import SwiftUI

struct SettingsPane: View {
    @ObservedObject var sim: Simulation
    var body: some View {
        Spacer()
        Spacer()
        HStack {
            HStack {
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
                            TextField("NumSteps", value: $sim.globals.default_step_count, formatter: NumberFormatter())
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 100)
                                .multilineTextAlignment(.trailing)
                            
                        } label: {
                            Text("Number of Steps:").frame(alignment: .leading)
                        }.frame(minWidth: 50)
                    }
                }.frame(minWidth: 50, maxWidth: 250)
            }.frame(minWidth: 50, maxWidth: 1080)
        }
    }
}
