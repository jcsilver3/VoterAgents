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

struct SimControlView: View {
    @ObservedObject var sim: Simulation
    @State private var runTask: Task<Void, Never>? = nil
    var body: some View {
        VStack {
            SettingsView(sim: sim)
            Spacer()
            Spacer()
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
                Button(action: {
                    runTask?.cancel()
                    Task {
                        sim.intervene_AddLiars()
                    }
                }, label: {
                    Text("Inject Liars")
                })
                Button(action: {
                    runTask?.cancel()
                    Task {
                        sim.intervene_RemoveLiars()
                    }
                }, label: {
                    Text("Remove Liars")
                })
            }
         
            Spacer()
            Spacer()

            SimProgressView(sim: sim)

        }
    }
}
