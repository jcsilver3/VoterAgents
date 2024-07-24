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
        ScrollView {
            VStack {
                SettingsPane(sim: sim)
                SimControlView(sim: sim)
                SimProgressView(sim: sim)
                Spacer()
                Spacer()
                Spacer()
            }.padding()
        }
    }
}
