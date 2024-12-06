//
//  Agent.swift
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
import SwiftUI

struct SimProgressView: View {
    @ObservedObject var sim: Simulation
    var body: some View {
        
        let progress = Double(sim.currentStep)/Double(sim.globals.default_step_count)
        let surviving: Int = sim.agents.filter({$0.age < sim.globals.default_max_age}).count
        let survivingPct: Double = ( Double(surviving)/Double(sim.agents.count))
        
        VStack {
            Text({if sim.isRunning{"Running"} else {"Stopped"}}())
            HStack {
                Text("Current Step: \(sim.currentStep)")
                Text("Active Agents: \(sim.agents.filter({$0.isAlive}).count)")
            }.padding()
            ProgressView(value: progress) {
                Text("Overall Progress")
            }
            ProgressView(value: survivingPct) {
                Text("Surviving Agents")
            }
        }
    }
}
