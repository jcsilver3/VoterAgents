//
//  ProgressView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//
import Foundation
import SwiftUI
import SwiftData

struct ViewPortView: View {
    @State private var isEditing = false
    @ObservedObject var sim: Simulation
    @State private var runTask: Task<Void, Never>? = nil
    var body: some View {
        ScrollView(.horizontal) {
            ScrollView {
                CanvasView().frame(minWidth: 1000, maxWidth: 1000, minHeight:1000, maxHeight: 1000).padding().environmentObject(sim)
            }
        }
    }
}
