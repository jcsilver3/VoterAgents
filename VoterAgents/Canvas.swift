//
//  Canvas.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
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
