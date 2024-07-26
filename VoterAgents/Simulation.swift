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
        //agents = tempAgents
        
        for agent in agents {
            for neighbor in agent.neighborNodes {
                let neighboragent = self.agents.first(where: {$0.graphID == neighbor.id})
                agent.neighborAgents.append(neighboragent!)
            }
        }
               //_ = await t3.result
        /*
        for agent in agents {
            
            print("\(agent.graphID) eigenvalue: \(agent.eigenvalue)")

        }
        */
        isRunning = false
    }
    func intervene_AddLiars() {
        let liarCount = self.agents.filter({$0.isLiar}).count
        if (liarCount < globals.default_liar_count) {
            for i in 1...globals.default_liar_count-liarCount {
                var target_liar = self.agents.filter({$0.eigenvalue > globals.default_liar_gt_eigenvalue && !$0.isLiar}).randomElement()
                target_liar?.isLiar = true
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
                        //print("Waiting...")
                        try await Task.sleep(nanoseconds: self.globals.delayNs() )
                    }
                }
                _ = await waitTask.result
                
                if globals.default_metrics_enabled && (currentStep <= 1 || currentStep % self.globals.metricModulus() == 0 || currentStep == self.globals.default_step_count) {
                    let t2 = Task {
                        recordMetrics()
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
    /*
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
        if globals.default_metrics_enabled && (currentStep <= 1 || currentStep % self.globals.metricModulus() == 0 || currentStep == self.globals.default_step_count) {
            let t2 = Task {
                recordMetrics()
            }
            _ = await t2.result
        }
    }
    */
    func recordMetrics() {
        //let t = Task {
            metrics.agentsBias.removeAll()
            metrics.agentsBiasPerceived.removeAll()
            
            metrics.agentsAlive.append(observation_int(key: currentStep, value: agents.filter({$0.age < self.globals.default_max_age}).count))
            metrics.agentsDead.append(observation_int(key: currentStep, value: agents.filter({$0.age >= self.globals.default_max_age}).count))
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
        //}
        //_ = await t.result
       
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
