//
//  Utility.swift
//  VoterAgents
//
//  Created by John Silver on 7/23/24.
//

import Foundation

func dictToArray(dict: Dictionary<Int,Int>) -> [[Int]] {
    var keys = dict.keys
    var data = [[Int]]()
    for key in keys {
        data.append([key,Int(dict[key]!)])
    }
    return data
}
