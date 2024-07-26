//
//  SimControlView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
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
