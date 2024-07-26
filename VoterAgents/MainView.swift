//
//  MainView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    //@State private var isEditing = false
    @ObservedObject var sim: Simulation
    @State private var runTask: Task<Void, Never>? = nil
    var body: some View {
        VStack {
            SimControlView(sim: sim)
            Spacer()
            Spacer()
            Spacer()
            if sim.globals.default_viewport_enabled {
                ViewPortView(sim: sim).padding()
            } else {
                Text("ViewPort disabled.")
            }
        }
    }
}
