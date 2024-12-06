//
//  SettingsView.swift
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
                    Text("Liar Eigenvalue >= x").frame(alignment: .leading)
                }.frame(minWidth: 50)
            }
            
            HStack {    LabeledContent {
                TextField("Bias to (+/- 0.00)", value: $sim.globals.default_liar_bias_to, format:.number)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 100)
                    .multilineTextAlignment(.trailing)
                
            } label: {
                Text("Bias to (+/- 0.00)").frame(alignment: .leading)
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
                        Text("Speed:")
                    }.frame(minWidth: 50, maxWidth: 250)
                }
                Spacer()
                Spacer()
                
            }
        }
    }
}
    

