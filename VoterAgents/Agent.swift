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
    let rng = GKRandomSource()
    
    init(globals: Globals, age: Double) {
        self.globals = globals
        self.age = Double.random(in: 0..<globals.default_max_age)
        self.speed = Int(globals.default_agent_speed)
        self.xpos = Int.random(in: 1..<globals.default_max_xpos)
        self.ypos = Int.random(in: 1..<globals.default_max_xpos)
        self.age = age
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
}
