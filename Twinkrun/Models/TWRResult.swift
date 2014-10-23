//
//  TWRResult.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreGraphics

class TWRResult: NSObject, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {
    let player: TWRPlayer
    let others: [TWRPlayer]
    let scores: Array<(role: TWRRole, scores: [Int])>
    let score: Int
    let option: TWRGameOption
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: Array<(role: TWRRole, scores: [Int])>, score: Int, option: TWRGameOption) {
        self.player = player
        self.others = others
        self.scores = scores
        self.score = score
        self.option = option
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return 5
    }

    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {
        return 100
    }
}