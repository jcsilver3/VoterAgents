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
import SwiftUI

struct ContentView: View {
    @StateObject var sim = Simulation()
    @StateObject var globals = Globals()
    
    @State private var runTask: Task<Void, Never>? = nil
    @State private var selectedView: String? = "Plots"
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selectedView) {
                
                NavigationLink(value: "Plots", label: {Text("Plots")})
                NavigationLink(value: "Viewport", label: {Text("Viewport")})
            }
            	
        } detail: {
            ScrollView {
                switch selectedView {
                case "Viewport":
                    MainView(sim: sim).padding()
                case "Plots":
                    MetricsView(sim: sim).padding()
                default:
                    MainView(sim: sim).padding()
                }
            }.padding()
        }
    
    }	
}	

#Preview {
    ContentView()
}
