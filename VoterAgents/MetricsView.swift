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
        let labelWidthMin = 100.00
        let labelWidthMax = 100.00
        let chartHeightMin = 200.00
        let listWidthMin = 200.00
        let listWidthMax = 200.00
        if sim.globals.default_metrics_enabled {
            VStack {
                SimControlView(sim: sim)
                Spacer()
                Text("Metrics:")
                Button("Clear Metrics", action: {
                    sim.metrics.clear()
                    sim.objectWillChange.send()
                })
                Group {
                    VStack {
                        Text("Liars: \(sim.agents.filter({$0.isLiar == true}).count)")
                    }
                }
                Group {
                    HStack {
                        Text("Degree Distribution:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        let data = sim.graph.k_dist_data()
                        Chart(data) {
                            PointMark (
                                x: .value("k", $0.key),
                                y: .value("f(x)", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin).chartXScale(type: .log).chartYScale(type: .log)
                        .chartXAxisLabel("k")
                        .chartYAxisLabel("f(k)")
                        
                    }.padding()
                    Text("Average Degree: \(Decimal(sim.graph.kHat))")
                }
                Group {
                    HStack {
                        Text("EignenValue Distribution:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        let data = sim.graph.l_dist_data()
                        Chart(data) {
                            PointMark (
                                x: .value("λ", $0.key),
                                y: .value("n", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXScale(type: .symmetricLog)
                        .chartYScale(type: .symmetricLog)
                        .chartXAxisLabel("Eigenvalue")
                        .chartYAxisLabel("n")
                        
                    }.padding()
                }
                Group {
                    HStack {
                        Text("EignenValue Convergence:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        let data = sim.metrics.err
                        Chart(data) {
                            LineMark (
                                x: .value("iteration", $0.key),
                                y: .value("e", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXScale(type: .symmetricLog)
                        .chartYScale(type: .symmetricLog)
                        .chartXAxisLabel("Iterations")
                        .chartYAxisLabel("Norm. Err.")
                        
                    }.padding()
                    Text("Max λ: \(Decimal(sim.graph.lambda_max).formatted())")
                }
                
                Group {
                    HStack {
                        Text("Agent Bias").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        if sim.globals.default_metric_show_lists {
                            List(sim.metrics.agentsBias, id: \.id) { entry in
                                Text("\(entry.key), \(entry.value)")
                            }.frame(minWidth: listWidthMin, maxWidth: listWidthMax).padding()
                        }
                        Chart(sim.metrics.agentsBias) {
                            BarMark(
                                x: .value("Bias", $0.key),
                                y: .value("f(x)", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXAxisLabel("Bias")
                        .chartYAxisLabel("f(x)")
                    }.padding()
                }
                Group {
                    HStack {
                        Text("Agent Bias - Perceived").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        if sim.globals.default_metric_show_lists {
                            List(sim.metrics.agentsBiasPerceived, id: \.id) { entry in
                                Text("\(entry.key), \(entry.value)")
                            }.frame(minWidth: listWidthMin, maxWidth: listWidthMax).padding()
                        }
                        Chart(sim.metrics.agentsBiasPerceived) {
                            BarMark(
                                x: .value("Bias", $0.key),
                                y: .value("f(x)", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXAxisLabel("Bias")
                        .chartYAxisLabel("f(x)")
                    }.padding()
                }
                Group {
                    HStack {
                        Text("Agents Alive:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        if sim.globals.default_metric_show_lists {
                            List(sim.metrics.agentsAlive, id: \.id) { entry in
                                Text("\(entry.key), \(entry.value)")
                            }.frame(minWidth: listWidthMin, maxWidth: listWidthMax).padding()
                        }
                        Chart(sim.metrics.agentsAlive) {
                            LineMark(
                                x: .value("Step", $0.key),
                                y: .value("Agents Alive", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXAxisLabel("Step")
                        .chartYAxisLabel("Agents Alive")
                    }.padding()
                }
                Group {
                    HStack {
                        Text("Agents Dead:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        if sim.globals.default_metric_show_lists {
                            List(sim.metrics.agentsDead, id: \.id) { entry in
                                Text("\(entry.key), \(entry.value)")
                            }.frame(minWidth: listWidthMin, maxWidth: listWidthMax).padding()
                        }
                        Chart(sim.metrics.agentsDead) {
                            LineMark(
                                x: .value("Step", $0.key),
                                y: .value("Agents Dead", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXAxisLabel("Step")
                        .chartYAxisLabel("Agents Dead")
                    }.padding()
                }
                Group {
                    HStack {
                        Text("Avg Age:").frame(minWidth: labelWidthMin, maxWidth: labelWidthMax)
                        if sim.globals.default_metric_show_lists {
                            List(sim.metrics.agentsAvgAge, id: \.id) { entry in
                                Text("\(entry.key), \(entry.value)")
                            }.frame(minWidth: listWidthMin, maxWidth: listWidthMax).padding()
                        }
                        Chart(sim.metrics.agentsAvgAge) {
                            LineMark(
                                x: .value("Step", $0.key),
                                y: .value("Mean Agent Age", $0.value)
                            )
                        }
                        .frame(minHeight: chartHeightMin)
                        .chartXAxisLabel("Step")
                        .chartYAxisLabel("Mean Agent Age")
                    }.padding()
                }
            }
        } else {
            Text("Metrics disabled.")
        }
    }
}
