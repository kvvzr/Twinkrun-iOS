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
    var focusOnGraph = true
    
    init(player: TWRPlayer, others: [TWRPlayer], scores: Array<(role: TWRRole, scores: [Int])>, score: Int) {
        self.date = NSDate()
        self.player = player
        self.others = others
        self.score = score

        var tmpScores = [Int]()
        var tmpRoles = [TWRRole]()
        for roleAndScores in scores {
            tmpScores += roleAndScores.scores
            tmpRoles.append(roleAndScores.role)
        }
        self.scores = tmpScores
        self.roles = tmpRoles
        maxScore = self.scores.maxElement()!
        minScore = self.scores.minElement()!
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _ = aDecoder.decodeObjectForKey("version") as? String {
            self.date = aDecoder.decodeObjectForKey("date") as! NSDate
            self.player = aDecoder.decodeObjectForKey("player") as! TWRPlayer
            self.others = aDecoder.decodeObjectForKey("others") as! [TWRPlayer]
            self.scores = aDecoder.decodeObjectForKey("scores") as! [Int]
            self.score = aDecoder.decodeIntegerForKey("score")
            self.roles = aDecoder.decodeObjectForKey("roles") as! [TWRRole]
        } else {
            self.date = NSDate()
            self.player = aDecoder.decodeObjectForKey("myDevice") as! TWRPlayer
            self.others = aDecoder.decodeObjectForKey("players") as! [TWRPlayer]
            var tmpScores = [Int]()
            var tmpRoles = [TWRRole]()
            let transitions = aDecoder.decodeObjectForKey("scores") as! [[String: AnyObject]]
            for trans in transitions {
                tmpScores += trans["scoreTransition"]! as! [Int]
                tmpRoles.append(TWRRole(name: "", color: trans["color"]! as! UIColor, count: 1, time: 3, score: 0))
            }
            self.scores = tmpScores
            self.roles = tmpRoles
            self.score = aDecoder.decodeIntegerForKey("score")
        }
        maxScore = self.scores.maxElement()!
        minScore = self.scores.minElement()!
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
    
    func makeRanking() -> [TWRPlayer] {
        var ranking = [TWRPlayer]()
        var tmp = others
        tmp.append(player)
        ranking = tmp.filter({ $0.score != nil })
        ranking.sortInPlace({ $0.score > $1.score })
        // ranking += tmp.filter({ $0.score == nil })
        return ranking
    }
    
    func rank(player: TWRPlayer) -> Int? {
        return makeRanking().indexOf(player)
    }
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return scores.count
    }

    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return CGFloat(scores[index])
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return CGFloat(maxScore)
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return CGFloat(minScore)
    }
}