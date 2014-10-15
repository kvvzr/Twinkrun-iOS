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
    let scores: [(TWRRole, [Int])]
    let score: Int
    let option: TWRGameOption
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: [(TWRRole, [Int])], score: Int, option: TWRGameOption) {
        self.player = player
        self.others = others
        self.scores = scores
        self.score = score
        self.option = option
    }
}