//
//  ViewPortView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI

struct ViewPortView: View {
    @ObservedObject var sim: Simulation
    var body: some View {
        if sim.globals.default_viewport_enabled {
            ScrollView {
                VStack {
                    Spacer()
                    Spacer()
                    
                        SimControlView(sim: sim)
                        SimProgressView(sim: sim)
                        ScrollView(.horizontal) {
                            ScrollView {
                                CanvasView().frame(minWidth: 1000, maxWidth: 1000, minHeight:1000, maxHeight: 1000).padding().environmentObject(sim)
                            }
                        }
                }
            }
        } else {
            Text("Viewport disabled.")
        }
    }
}
