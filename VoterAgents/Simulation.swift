//
//  Sim.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
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
        
        var tempAgents: [Agent] = []
        let t = Task {
           
            graph = generateBarabasiAlbert(nodeCount: agentCount, m0: self.globals.default_graph_m0)
            logger.log(message: "Graph has \(graph.nodes.count) nodes and \(graph.edges.count) edges. k_Min:\(graph.k_min()), k_Max:\(graph.k_max())")
            self.objectWillChange.send()
        }
        await _ = t.result	
        let t2 = Task {
            graph.kHat = graph.k_hat()
            logger.log(message:"Graph has average degree of \(graph.kHat.rounded())")
        }
        await _ = t2.result
        /* make age distribution roughly normally distributed */
        let rngNorm = GKGaussianDistribution(randomSource: randomSource, lowestValue: 0, highestValue: Int(self.globals.default_max_age))
        Task {
            for _ in 1...self.globals.default_agent_count {
                tempAgents.append(Agent(globals: self.globals, age: Double(rngNorm.nextInt())))
            }
            agents = tempAgents
        }
        isRunning = false
    }
    func run() async -> Void {
        isRunning = true
        currentStep = 0
        for _ in 1...Int(self.globals.default_step_count){
            currentStep += 1	
            self.logger.log(message:"Step \(currentStep)")
            if self.isRunning {
                let t = Task {
                    await step()
                    self.objectWillChange.send()
                }
                _ = await t.result
                
                let waitTask = Task {
                    if self.globals.delayNs() > 0 {
                        try await Task.sleep(nanoseconds: self.globals.delayNs() )
                    }
                }
                _ = await waitTask.result
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
                Task {
                    try Task.checkCancellation()
                    await a.step()
                }
            }
        }
        _ = await t.result
        if globals.default_metrics_enabled && (currentStep <= 1 || currentStep % self.globals.metricModulus() == 0 || currentStep == self.globals.default_step_count) {
            await recordMetrics()
        }
    }
    func stepGroups() async -> Void {
        let t = Task {
            await withTaskGroup(of: Void.self) { group in
                for a in self.agents {
                    if isRunning {
                        group.addTask {
                            Task {
                                try Task.checkCancellation()
                                await a.step()
                            }
                        }
                    }
                }
            }
        }
        _ = await t.result
    }
    func recordMetrics() async -> Void {
        let _ = Task {
            metrics.agentsAlive.append(observation_int(step: currentStep, value: agents.filter({$0.age < self.globals.default_max_age}).count))
            metrics.agentsDead.append(observation_int(step: currentStep, value: agents.filter({$0.age >= self.globals.default_max_age}).count))
            metrics.agentsAvgAge.append(observation_int(step: currentStep, value: {
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
    }
    func stop() {
        self.isRunning = false
    }
}
/*
func run() {
    let printEdges = 0
    let printNodes = 0
    let printKdist = 1
    var logger = Logger()
    let g: Graph = generateBarabasiAlbert(nodeCount: 100000, m0: 3)
    logger.log("Graph has \(g.nodes.count) nodes and \(g.edges.count) edges. K-Min:\(g.k_min()), K-Max:\(g.k_max())")
    
    if printKdist == 1 {
        for k in g.k_dist() {
            logger.log(message:"\(k.key), \(k.value)")
        }
    }
    if printEdges == 1 {
        print("i, j")
        for edge in g.edges {
            logger.log(message:"\(edge[0].id),\(edge[1].id)")
        }
    }
    if printNodes == 1 {
        print("id, k")
        for node in g.nodes {
            logger.log(message:"\(node.id), \(node.degree())")
        }
        
    }
}
*/
