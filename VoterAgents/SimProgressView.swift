//
//  ProgressView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
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
