//
//  Graph.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

class Graph {
    var nodes: [Node] = [Node]()
    var edges: [[Node]] = [[Node]]()
    var edgeNodes: [Node] = [Node]()
    var kHat: Double = 0
    
    func k_dist() -> Dictionary<Int, Int>{
        var k_dist: Dictionary<Int, Int> = Dictionary()
        for node in self.nodes {
            let key = node.k()
            let newValue = (k_dist[node.k()] ?? 0) + 1
            k_dist.updateValue(newValue, forKey: key)
        }
       return k_dist
    }
    struct Data:Identifiable {
        let id = UUID()
        let key: Int
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
            print(node.k())
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
    var cc: Double = 0
    
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
