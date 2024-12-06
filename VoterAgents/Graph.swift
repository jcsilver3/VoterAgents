//
//  Graph.swift
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

class Graph: ObservableObject {
    var nodes: [Node] = [Node]()
    var edges: [[Node]] = [[Node]]()
    var edgeNodes: [Node] = [Node]()
    var kHat: Double = 0.0
    var lambda_max: Double = 0.0
    func k_dist() -> Dictionary<Int, Int>{
        var k_dist: Dictionary<Int, Int> = Dictionary()
        for node in self.nodes {
            let key = node.k()
            let newValue = (k_dist[node.k()] ?? 0) + 1
            k_dist.updateValue(newValue, forKey: key)
        }
       return k_dist
    }
    func l_dist() -> Dictionary<Double, Int>{
        var l_dist: Dictionary<Double, Int> = Dictionary()
        for node in self.nodes {
            let key = node.lambda
            let newValue = (l_dist[node.lambda] ?? 0) + 1
            l_dist.updateValue(newValue, forKey: key)
        }
       return l_dist
    }
    struct Data:Identifiable {
        let id = UUID()
        let key: Int
        let value: Int
    }
    
    struct Data_key_dbl:Identifiable {
        let id = UUID()
        let key: Double
        let value: Int
    }
    func k_dist_data() -> [Data] {
        var output = [Data]()
        for (k,v) in k_dist() {
            let data = Data(key: k, value: v)
            output.append(data)
        }
        return output
    }
    func l_dist_data() -> [Data_key_dbl] {
        var output = [Data_key_dbl]()
        for (k,v) in l_dist() {
            let data = Data_key_dbl(key: k, value: v)
            output.append(data)
        }
        return output
    }
    func k_max() -> Int {
        var kmax = 0
        for node in self.nodes {
            if node.degree() > kmax {
                kmax = node.degree()
            }
        }
        return kmax
    }
    func k_min() -> Int {
        var kmin: Int?
        for node in self.nodes {
            if kmin == nil {
                kmin = node.degree()
            } else {
                if node.degree() < kmin! {
                    kmin = node.degree()
                }
            }
        }
        return kmin!
    }
    func k_hat() -> Double {
        var k_hat = 0.00
        for node in self.nodes {
            k_hat += Double(node.k())
        }
        k_hat = k_hat / Double(self.nodes.count)
        return k_hat
    }
   
}
/* Local CC
 CC(v) = 2Nv/Kv(Kv-1)
 
 */
class Node: Identifiable, Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    var id: Int
    var neighbors = [Node]()
    var lambda: Double = 0.0
    
    init(id: Int = 0) {
        self.id = id
    }
    func k() -> Int {
        return degree()
    }
    func degree() -> Int {
        return neighbors.count
    }
    
}

func generateBarabasiAlbert(nodeCount: Int, m0: Int) -> Graph {
    let g = Graph()
    for i in 1...nodeCount {
        let node_i = Node(id: i)
        g.nodes.append(node_i)
        var node_j: Node
        let m = m0//Int.random(in:1...m0)
        for _ in 1...m {
            if g.edgeNodes.count == 0 {
                node_j = node_i
            } else {
                node_j = g.edgeNodes.randomElement()!
            }
            g.edges.append([node_i,node_j])
            g.edgeNodes.append(node_i)
            g.edgeNodes.append(node_j)

            node_i.neighbors.append(node_j)
            node_j.neighbors.append(node_i)
        }
    }
    return g
}
