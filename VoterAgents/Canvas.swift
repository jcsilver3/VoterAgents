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

import SwiftUI
struct CanvasView: View {
    @EnvironmentObject var sim: Simulation //= Simulation()
    var body: some View {
        Canvas(
            opaque: true,
            colorMode: .linear,
            rendersAsynchronously: true
        ) { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color(.sRGB, red: 230/255, green: 240/255, blue: 1, opacity: 0.50)))

            let ceiling = 20000
            let agentsAlive = sim.agents.filter({$0.isAlive}).count
            for agent in sim.agents.filter({$0.isAlive}) {
                if Int.random(in: 0...agentsAlive) < ceiling {
                    let xpos = agent.xpos
                    let ypos = agent.ypos
                    var img = context.resolve(Image(systemName: {if agent.isSelected {"person.fill.viewfinder"} else {"person.fill"}}()))
                    img.shading = .color(agent.ageColor())//.color({if agent.isSelected == true {.red} else {.white}}())
                    context.opacity = 0.75
                    context.draw(img, at: CGPoint(x: xpos, y: ypos))

                }
            }
        }
    }
}
