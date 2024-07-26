//
//  Metrics.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

class Metrics: ObservableObject {
    var agentsAlive: [observation_int]
    var agentsDead: [observation_int]
    var agentsAvgAge: [observation_int]
    var agentsBias: [observation_double]
    var agentsBiasPerceived: [observation_double]
    var agentsEigenDist: [observation_keydouble]
    var agentsBiasError: [observation_double]
    var err: [observation_double]
    init() {
        self.agentsAlive = [observation_int]()
        self.agentsDead = [observation_int]()
        self.agentsAvgAge = [observation_int]()
        self.agentsBias = [observation_double]()
        self.agentsBiasPerceived = [observation_double]()
        self.agentsEigenDist = [observation_keydouble]()
        self.agentsBiasError = [observation_double]()
        self.err = [observation_double]()
    }
    func clear() {
        self.agentsAlive.removeAll()
        self.agentsDead.removeAll()
        self.agentsAvgAge.removeAll()
        self.agentsBias.removeAll()
        self.agentsBiasPerceived.removeAll()
        self.agentsEigenDist.removeAll()
        self.agentsBiasError.removeAll()
        self.err .removeAll()
    }
}
struct observation_int: Identifiable {
    var id = UUID()
    var key: Int = 0
    var value: Int = 0
}

struct observation_keydouble: Identifiable {
    var id = UUID()
    var key: Double = 0.0
    var value: Double = 0.0
}
struct observation_double: Identifiable {
    var id = UUID()
    var key: Double = 0.0
    var value: Double = 0.0
}
