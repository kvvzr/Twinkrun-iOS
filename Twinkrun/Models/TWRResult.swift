//
//  TWRResult.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreGraphics

class TWRResult: NSObject, NSCoding, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {
    let player: TWRPlayer
    let others: [TWRPlayer]
    let scores: Array<(role: TWRRole, scores: [Int])>?
    let score: Int
    let option: TWRGameOption
    var flattenScores: [Int]
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: Array<(role: TWRRole, scores: [Int])>, score: Int, option: TWRGameOption) {
        self.player = player
        self.others = others
        self.scores = scores
        self.score = score
        self.option = option
        
        flattenScores = []
        for roleAndScores in scores {
            flattenScores += roleAndScores.scores
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.player = aDecoder.decodeObjectForKey("player") as TWRPlayer
        self.others = aDecoder.decodeObjectForKey("others") as [TWRPlayer]
        self.flattenScores = aDecoder.decodeObjectForKey("scores") as [Int]
        self.score = aDecoder.decodeIntegerForKey("score")
        self.option = aDecoder.decodeObjectForKey("option") as TWRGameOption
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(player, forKey: "player")
        aCoder.encodeObject(others, forKey: "others")
        aCoder.encodeObject(flattenScores, forKey: "scores")
        aCoder.encodeInteger(score, forKey: "score")
        aCoder.encodeObject(option, forKey: "option")
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return flattenScores.count
    }

    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(flattenScores[index])
    }
}