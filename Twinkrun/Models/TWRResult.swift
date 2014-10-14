//
//  TWRResult.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation

class TWRResult {
    let player: TWRPlayer
    let others: [TWRPlayer]
    let scores: [(TWRColor, [Int])]
    let score: Int
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: [(TWRColor, [Int])], score: Int) {
        self.player = player
        self.others = others
        self.scores = scores
        self.score = score
    }
}