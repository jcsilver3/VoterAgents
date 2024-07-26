//
//  Eigenvector.swift
//  VoterAgents
//
//  Created by John Silver on 7/26/24.
//

import Foundation

func updateEigenValues(G: Graph, metrics: Metrics, logger: Logger) {
    
    var maxTries = 100
    var fn: Double = 0 /* Frobenius Norm */
    var fn_1: Double = Double.infinity
    var lambda_max: Double = 0
    var err: Double = Double.infinity
    let err_tolerance: Double = 0//0.00000000001
    var node_dict = [Int: [Double]]()
    //var norm_frob: Double = 0.0
    for node in G.nodes {
        node_dict[node.id] = [Double(node.k()),0]
        fn += pow(node_dict[node.id]![0],2)
    }
    fn = sqrt(fn)
    /* Normalize node λ */
    for node in node_dict {
        node_dict[node.key]![0] /= fn
        fn += node.value[0] * node.value[0]
    }
    let maxTries_start = maxTries
    
    while err > err_tolerance && maxTries >= 0 {
        logger.log(message:"Eigenvector iteration \(maxTries_start-maxTries)")
        fn_1 = 0
        lambda_max = 0
        for node in G.nodes {
            node_dict[node.id]![1] = 0
            for neighbor in node.neighbors {
                node_dict[node.id]![1] += node_dict[neighbor.id]![0]
            }
            fn_1 += pow(node_dict[node.id]![1],2)
        }
        fn_1 = sqrt(fn_1)
        /* normalize and update */
        for node in G.nodes {
            node_dict[node.id]![0] = node_dict[node.id]![1] / fn_1
            node_dict[node.id]![1] = 0
            node.lambda = node_dict[node.id]![0]
            lambda_max = max(lambda_max, node.lambda)
        }
        err = abs(fn-fn_1)
        fn = fn_1
        logger.log(message:"Eigenvector iteration convergence:\(err)")
        //norm_frob = fn
        G.lambda_max = lambda_max

        metrics.err.append(observation_double(key: Double(maxTries_start - maxTries), value: err))
        metrics.objectWillChange.send()
        maxTries -= 1

    }
}
