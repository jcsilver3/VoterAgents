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
    @State private var selectedView: String? = "Main"
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selectedView) {
                NavigationLink(value: "Main", label: {Text("Main")})
                NavigationLink(value: "ViewPort", label: {Text("ViewPort")})
                NavigationLink(value: "Metrics", label: {Text("Metrics")})
                NavigationLink(value: "Log", label: {Text("Log")})
            }
            
        } detail: {
            switch selectedView {
            case "Main":
                MainView(sim: sim)
            case "ViewPort":
                ViewPortView(sim: sim)
            case "Metrics":
                MetricsView(sim: sim)
            case "Log":
                LogView(sim: sim)
            default:
                MainView(sim: sim)
            }
        }
    
    }
}	

#Preview {
    ContentView()
}
