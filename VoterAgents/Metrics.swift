//
//  Agent.swift
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
