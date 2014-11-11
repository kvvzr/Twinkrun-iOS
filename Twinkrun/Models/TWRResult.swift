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
    let date: NSDate
    let player: TWRPlayer
    let others: [TWRPlayer]
    let score: Int
    let scores: [Int]
    let maxScore: Int, minScore: Int
    let roles: [TWRRole]
    let version = "2.0"
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: Array<(role: TWRRole, scores: [Int])>, score: Int) {
        self.date = NSDate()
        self.player = player
        self.others = others
        self.score = score
        
        self.scores = []
        self.roles = []
        for roleAndScores in scores {
            self.scores += roleAndScores.scores
            self.roles.append(roleAndScores.role)
        }
        maxScore = maxElement(self.scores)
        minScore = minElement(self.scores)
    }
    
    required init(coder aDecoder: NSCoder) {
        if let version = aDecoder.decodeObjectForKey("version") as? String {
            self.date = aDecoder.decodeObjectForKey("date") as NSDate
            self.player = aDecoder.decodeObjectForKey("player") as TWRPlayer
            self.others = aDecoder.decodeObjectForKey("others") as [TWRPlayer]
            self.scores = aDecoder.decodeObjectForKey("scores") as [Int]
            self.score = aDecoder.decodeIntegerForKey("score")
            self.roles = aDecoder.decodeObjectForKey("roles") as [TWRRole]
        } else {
            self.date = NSDate()
            self.player = aDecoder.decodeObjectForKey("myDevice") as TWRPlayer
            self.others = aDecoder.decodeObjectForKey("players") as [TWRPlayer]
            self.scores = []
            self.roles = []
            let transitions = aDecoder.decodeObjectForKey("scores") as [[String: AnyObject]]
            for trans in transitions {
                self.scores += trans["scoreTransition"]! as [Int]
                self.roles.append(TWRRole(name: "", color: trans["color"]! as UIColor, count: 1, time: 3, score: 0))
            }
            self.score = aDecoder.decodeIntegerForKey("score")
        }
        maxScore = maxElement(self.scores)
        minScore = minElement(self.scores)
    }
    
    func dateText() -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(player, forKey: "player")
        aCoder.encodeObject(others, forKey: "others")
        aCoder.encodeObject(scores, forKey: "scores")
        aCoder.encodeInteger(score, forKey: "score")
        aCoder.encodeObject(roles, forKey: "roles")
        aCoder.encodeObject(version, forKey: "version")
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return scores.count
    }

    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(scores[index])
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
        return CGFloat(maxScore)
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
        return CGFloat(minScore)
    }
}