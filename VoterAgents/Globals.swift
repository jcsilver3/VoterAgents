//
//  Globals.swift
//  VoterAgents
//
//  Created by John Silver on 7/24/24.
//

import Foundation

class Globals: ObservableObject {
    
    @Published var default_agent_count: Int = 10000
    @Published var default_graph_m0: Int = 10
    @Published var default_step_count: Int = 1000
    @Published var default_min_ypos: Int = 0
    @Published var default_min_xpos: Int = 0
    @Published var default_max_xpos: Int = 1000
    @Published var default_max_ypos: Int = 1000
    @Published var default_max_age: Double = 1000.0
    @Published var default_agent_speed: Double = 10.00
    @Published var default_sim_speed: Double = 20.00
    @Published var default_max_sim_speed: Double = 20.00
    @Published var default_max_agent_speed: Double = 25.00
    @Published var default_metric_calculate_samples: Int = 1000
    @Published var default_metric_show_lists: Bool = false
    @Published var default_viewport_enabled: Bool = true
    @Published var default_logging_enabled: Bool = true
    @Published var default_metrics_enabled: Bool = true
    func metricModulus() -> Int {
        return max(Int(default_step_count/default_metric_calculate_samples),1)
    }
    func delayNs() -> UInt64 {
        var n: UInt64 = 0
        if default_max_sim_speed != default_sim_speed {
            do {
                n = UInt64(0 + (2_500_000 * pow(Double(20 - Int(self.default_sim_speed)),2.45)))
            } catch {
                print("Error setting speed \(self.default_sim_speed).")
            }
        }
        return n
    }
}
