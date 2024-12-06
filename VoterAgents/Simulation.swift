//
//  Simulation.swift
//  VoterAgents
//  This file is part of the VoterAgents program, an Agent Based Model (ABM) simulation of misinformation perception.
//  Copyright (C) 2024 John Silver (jcsilver3@gmail.com, jsilver9@gmu.edu)
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation
import GameKit

@MainActor

class Simulation: ObservableObject {
    
    @Published var agents: [Agent] = []
    @Published var currentStep = 0
    @Published var isRunning: Bool = false
    @Published var globals = Globals()
    @Published var graph = Graph()
    @Published var metrics = Metrics()
 
    let randomSource = GKRandomSource()
    @Published var logger = Logger()
    
    init() {
        Task {
            await reset()
        }
    }
    func reset() async {
        await reset(agentCount: self.globals.default_agent_count, stepCount: Double(self.globals.default_step_count))
    }
    func reset(agentCount: Int, stepCount: Double) async {
        isRunning = true
        agents = []
        currentStep = 0
        metrics.clear()
        logger.log(message:"Reset.")
        
        //var tempAgents: [Agent] = []
        
        /* Generate Graph */
        graph = generateBarabasiAlbert(nodeCount: agentCount, m0: self.globals.default_graph_m0)
        
        /* Calculate Eigenvector Centrality */
        updateEigenValues(G: graph, metrics: metrics, logger: logger)
        
        logger.log(message: "Graph has \(graph.nodes.count) nodes and \(graph.edges.count) edges. k_Min:\(graph.k_min()), k_Max:\(graph.k_max())")
        
        graph.kHat = graph.k_hat()
        logger.log(message:"Graph has average degree of \(graph.kHat.rounded())")

        /* make age & bias distributions roughly normally distributed */
        let rngNorm = GKGaussianDistribution(randomSource: randomSource, lowestValue: 0, highestValue: Int(self.globals.default_max_age))
        let biasNorm = GKGaussianDistribution(randomSource: randomSource, lowestValue: -100, highestValue: 100)
        
        /* Map agents to Graph */
        for i in 0..<graph.nodes.count {
            var bias: Double = Double(biasNorm.nextUniform())
            bias = (pow(10,2) * bias).rounded() / pow(10,2)
            agents.append(Agent(globals: self.globals, age: Double(rngNorm.nextInt()), bias: bias, graphID: graph.nodes[i].id, neighborNodes: graph.nodes[i].neighbors, eigenvalue: graph.nodes[i].lambda))
        }

        for agent in agents {
            for neighbor in agent.neighborNodes {
                let neighboragent = self.agents.first(where: {$0.graphID == neighbor.id})
                agent.neighborAgents.append(neighboragent!)
            }
        }
        isRunning = false
    }
    func intervene_AddLiars() {
        let liarCount = self.agents.filter({$0.isLiar}).count
        if (liarCount < globals.default_liar_count) {
            for _ in 1...globals.default_liar_count-liarCount {
                let target_liar = self.agents.filter({$0.eigenvalue > globals.default_liar_gt_eigenvalue && !$0.isLiar}).randomElement()
                if target_liar != nil {
                    target_liar!.isLiar = true
                }
               
            }
        }
    }
    func intervene_RemoveLiars() {
        for agent in self.agents.filter({$0.isLiar}) {
            agent.isLiar = false
        }
    }
    func run() async -> Void {
        isRunning = true
        currentStep = 0
        for _ in 1...Int(self.globals.default_step_count){
            currentStep += 1
            Task {
                self.logger.log(message:"Step \(currentStep)")
            }
            if self.isRunning {
                let t = Task {
                    await step()
                }
                _ = await t.result
                
                let waitTask = Task {
                    if self.globals.delayNs() > 0 {
                        try await Task.sleep(nanoseconds: self.globals.delayNs() )
                    }
                }
                _ = await waitTask.result
                
                if globals.default_metrics_enabled && (currentStep <= 1 || currentStep % self.globals.metricModulus() == 0 || currentStep == self.globals.default_step_count) {
                    let t2 = Task {
                        await recordMetrics()
                    }
                    _ = await t2.result
                }
                
                if agents.filter({$0.isAlive}).count == 0 {
                    self.stop()
                }
                
            } else {
                return
            }
        }
        isRunning = false
    }
    
    func step() async -> Void {
        let t = Task {
            for a in self.agents {
                let ta = Task {
                    try Task.checkCancellation()
                    await a.step()
                }
                _ = await ta.result
            }
        }
        _ = await t.result
        
    }
    func recordMetrics() async {
        
        let t = Task {
            Task {
                try Task.checkCancellation()
                metrics.agentsBias.removeAll()
                metrics.agentsBiasPerceived.removeAll()
            }
            Task {
                try Task.checkCancellation()
                metrics.agentsAlive.append(observation_int(key: currentStep, value: agents.filter({$0.age < self.globals.default_max_age}).count))
            }
            Task {
                try Task.checkCancellation()
                metrics.agentsDead.append(observation_int(key: currentStep, value: agents.filter({$0.age >= self.globals.default_max_age}).count))
            }
            Task {
                try Task.checkCancellation()
                metrics.agentsAvgAge.append(observation_int(key: currentStep, value: {
                    var x: Double = 0
                    var n: Double = Double(self.agents.filter({$0.age < self.globals.default_max_age}).count)
                    
                    if n > 0 {
                        for agent in self.agents.filter({$0.age < self.globals.default_max_age}) {
                            x+=agent.age
                        }
                    } else {
                        n = 1
                    }
                    return Int(x/n)
                }()))
            }
            
            Task {
                try Task.checkCancellation()
                var biasDict: Dictionary<Double, Double> = Dictionary()
                for agent in self.agents {
                    let keyval = agent.bias
                    let key = keyval
                    let newValue = (biasDict[keyval] ?? 0) + 1
                    biasDict.updateValue(newValue, forKey: key)
                }
                for dictEntry in biasDict {
                    metrics.agentsBias.append(observation_double(key: dictEntry.key, value: dictEntry.value))
                }
            }
            Task {
                try Task.checkCancellation()
                
                var biasPerceivedDict: Dictionary<Double, Double> = Dictionary()
                for agent in self.agents {
                    let keyval = agent.bias_perceived
                    let key = keyval
                    let newValue = (biasPerceivedDict[keyval] ?? 0) + 1
                    biasPerceivedDict.updateValue(newValue, forKey: key)
                }
                for dictEntry in biasPerceivedDict {
                    metrics.agentsBiasPerceived.append(observation_double(key: dictEntry.key, value: dictEntry.value))
                }
            }
            Task {
                try Task.checkCancellation()
                var bias_total: Double = 0.0
                var bias_perceived_total: Double = 0.0
                var bias_err_sos: Double = 0.0
                for agent in self.agents {
                    bias_total += agent.bias
                    bias_perceived_total += agent.bias_perceived
                    bias_err_sos += pow((agent.bias_perceived - bias_total),2)
                }
                bias_err_sos = sqrt(bias_err_sos)
                metrics.agentsBiasError.append(observation_double(key: Double(currentStep), value: bias_err_sos))
            }
        }
        
        _ = await t.result
        
    }
    func stop() {
        self.isRunning = false
    }
}
