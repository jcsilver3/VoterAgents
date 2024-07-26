//
//  ContentView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sim = Simulation()
    @StateObject var globals = Globals()
    
    @State private var runTask: Task<Void, Never>? = nil
    @State private var selectedView: String? = "Metrics"
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selectedView) {
                NavigationLink(value: "Main", label: {Text("Main")})
                NavigationLink(value: "Metrics", label: {Text("Metrics")})
                NavigationLink(value: "Log", label: {Text("Log")})
            }
            	
        } detail: {
            ScrollView {
                switch selectedView {
                case "Main":
                    MainView(sim: sim).padding()
                case "Metrics":
                    MetricsView(sim: sim).padding()
                case "Log":
                    LogView(sim: sim).padding()
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
