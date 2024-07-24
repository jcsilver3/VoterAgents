//
//  MetricsView.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI
import Charts
struct MetricsView: View {
    @ObservedObject var sim: Simulation
    var body: some View {
        if sim.globals.default_metrics_enabled {
            ScrollView {
                VStack {
                        SimControlView(sim: sim)
                        SimProgressView(sim: sim)
                        Text("Metrics:")
                        Button("Clear Metrics", action: {
                            sim.metrics.clear()
                            sim.objectWillChange.send()
                        })
                        HStack {
                            Text("Agents Alive:").frame(minWidth: 50, maxWidth: 50)
                            if sim.globals.default_metric_show_lists {
                                List(sim.metrics.agentsAlive, id: \.id) { entry in
                                    Text("\(entry.step), \(entry.value)")
                                }.frame(minWidth: 200, maxWidth: 200).padding()
                            }
                            Chart(sim.metrics.agentsAlive) {
                                LineMark(
                                    x: .value("Step", $0.step),
                                    y: .value("Agents Alive", $0.value)
                                )
                            }.frame(minHeight: 200)
                        }.padding()
                        HStack {
                            Text("Agents Dead:").frame(minWidth: 50, maxWidth: 50)
                            if sim.globals.default_metric_show_lists {
                                List(sim.metrics.agentsDead, id: \.id) { entry in
                                    Text("\(entry.step), \(entry.value)")
                                }.frame(minWidth: 200, maxWidth: 200).padding()
                            }
                            Chart(sim.metrics.agentsDead) {
                                LineMark(
                                    x: .value("Step", $0.step),
                                    y: .value("Agents Dead", $0.value)
                                )
                            }.frame(minHeight: 200)
                        }.padding()
                        HStack {
                            Text("Avg Age:").frame(minWidth: 50, maxWidth: 50)
                            if sim.globals.default_metric_show_lists {
                                List(sim.metrics.agentsAvgAge, id: \.id) { entry in
                                    Text("\(entry.step), \(entry.value)")
                                }.frame(minWidth: 200, maxWidth: 200).padding()
                            }
                            Chart(sim.metrics.agentsAvgAge) {
                                LineMark(
                                    x: .value("Step", $0.step),
                                    y: .value("Agents Dead", $0.value)
                                )
                            }.frame(minHeight: 200)
                        }.padding()
                        HStack {
                        Text("Degree Distribution:").frame(minWidth: 50, maxWidth: 50)
                            var data = sim.graph.k_dist_data()
                            Chart(data) {
                                PointMark (
                                x: .value("k", $0.key),
                                y: .value("f(x)", $0.value)
                                )
                            }.frame(minHeight: 200).chartXScale(type: .log).chartYScale(type: .log)
                            
                        }.padding()
                        Text("Average Degree: \(Decimal(sim.graph.kHat))")
                }.padding()
            }
        } else {
            Text("Metrics disabled.")
        }
    }
}
