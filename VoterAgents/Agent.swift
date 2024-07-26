//
//  Agent.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation
import SwiftUI
import GameKit

class Agent: Identifiable, Hashable, Equatable {
    var id = UUID()
    var age: Double //= Double(Int.random(in: 0..<100))
    var xpos: Int// = Int.random(in: 1..<1000)
    var ypos: Int// = Int.random(in: 1..<1000)
    var speed: Int // = 25
    var isSelected = false
    var isAlive = true
    var globals: Globals = Globals()
    var bias: Double = 0.00
    var bias_perceived: Double = 0.00
    var graphID: Int
    var neighborNodes: [Node]
    var neighborAgents = [Agent]()
    var eigenvalue: Double = 0.00
    var isLiar: Bool = false
    let randomSource = GKRandomSource()
    
    init(globals: Globals, age: Double, bias: Double, graphID: Int, neighborNodes: [Node], eigenvalue: Double) {
        self.bias = bias
        self.globals = globals
        self.age = Double.random(in: 0..<globals.default_max_age)
        self.speed = Int(globals.default_agent_speed)
        self.xpos = Int.random(in: 1..<globals.default_max_xpos)
        self.ypos = Int.random(in: 1..<globals.default_max_xpos)
        self.age = age
        self.graphID = graphID
        self.neighborNodes = neighborNodes
        self.eigenvalue = eigenvalue
    }

    func getAge() -> Double {
        return self.age
    }
    static func == (lhs: Agent, rhs: Agent) -> Bool {
        if lhs.id == rhs.id { return true } else {return false}
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    func perceive() {
        let rng = GKRandomDistribution(randomSource: self.randomSource, lowestValue: 0, highestValue: 10000)
        var observed_bias: Double = 0.0
        var flutter: Double = (Double(rng.nextUniform()) * globals.default_flutter_lt)
        flutter = (pow(10,2) * flutter).rounded() / pow(10,2)
        /* flip sign evenly */
        if rng.nextUniform() < 0.50 {
            flutter *= -1
        }

        observed_bias = self.bias

        /* scale neighbor influence by normalized eigenvalue relative to node */
        var lambda_tot: Double = 0.0
        
        for neighbor in self.neighborAgents {
            lambda_tot += neighbor.eigenvalue
        }
        
        for neighbor in self.neighborAgents {
            let lambda_relative = neighbor.eigenvalue / lambda_tot
            observed_bias += (neighbor.bias_perceived * lambda_relative)
        }
        
        observed_bias /= 2 // equally weigh internal vs. external bias.
        
        /* if liar, bias to configured value */
        if self.isLiar {
            observed_bias = globals.default_liar_bias_to
        }
        /* round to same precision as start */
        observed_bias = (pow(10,2) * (observed_bias + flutter)).rounded() / pow(10,2)
        self.bias_perceived = observed_bias
    }
    func ageColor() -> Color {
        if !isAlive {
            return Color.gray
        } else if isSelected {
            return Color.red
        } else if age < 18 {
            return Color.cyan
        } else if age >= 18 && age < 65 {
            return Color.white
        } else if age >= 65 && age < 100 {
            return Color.blue
        } else {
            return Color.black
        }
    }
    func step() async -> Void {
        if isAlive {
            if age >= self.globals.default_max_age {
                die()
            } else {
                
                perceive()
                
                age+=1
                xpos += Int.random(in: -speed..<speed+1)
                ypos += Int.random(in: -speed..<speed+1)
                
                if xpos > self.globals.default_max_xpos {
                    xpos = 0
                } else if xpos < 0 {
                    xpos = self.globals.default_max_xpos
                }
                if ypos > self.globals.default_max_ypos {
                    ypos = 0
                } else if ypos < 0 {
                    ypos = self.globals.default_max_ypos
                }
            }
        }
    }
    func die() {
        isAlive = false
    }
    func toString() -> String {
        var outstr: String = ""
        outstr += "id: \(self.id)\n"
        outstr += "graphId: \(self.graphID)\n"
        outstr += "k: \(self.neighborNodes.count)\n"
        outstr += "bias: \(self.bias)\n"
        outstr += "neighbors: "
        for neighbor in self.neighborNodes {
            outstr += "\(neighbor.id) "
            
        }
        return outstr
    }
}
