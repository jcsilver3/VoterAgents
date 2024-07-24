//
//  Metrics.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

class Metrics {
    var agentsAlive: [observation_int]
    var agentsDead: [observation_int]
    var agentsAvgAge: [observation_int]
    init() {
        self.agentsAlive = [observation_int]()
        self.agentsDead = [observation_int]()
        self.agentsAvgAge = [observation_int]()
    }
    func clear() {
        self.agentsAlive.removeAll()
        self.agentsDead.removeAll()
        self.agentsAvgAge.removeAll()
    }
}
struct observation_int: Identifiable {
    var id = UUID()
    var step: Int
    var value: Int
}
