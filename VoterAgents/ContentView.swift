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
