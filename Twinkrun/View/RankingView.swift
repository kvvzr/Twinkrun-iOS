//
//  RankingView.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/11/11.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit

class RankingView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var result: TWRResult?
    var ranking: [TWRPlayer]?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
        dataSource = self
        backgroundView = nil
        backgroundColor = UIColor.twinkrunBlack()
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        dataSource = self
        backgroundView = nil
        backgroundColor = UIColor.twinkrunBlack()
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result {
            return result.others.count + 1
        }
        return 0
    }
    
    func makeRanking() {
        if let result = result {
            var tmp = result.others
            tmp.append(result.player)
            ranking = tmp.filter({ $0.score != nil })
            ranking!.sort({ $0.score > $1.score })
            ranking! += tmp.filter({ $0.score == nil })
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Ranking"][section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view is UITableViewHeaderFooterView {
            var header = view as UITableViewHeaderFooterView
            header.contentView.backgroundColor = UIColor.twinkrunLightBlack()
            header.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("scoreCell")! as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        if let ranking = ranking {
            var nameLabel = cell.viewWithTag(8) as UILabel
            nameLabel.text = ranking[indexPath.row].name
            nameLabel.textColor = UIColor.whiteColor()
            
            var scoreLabel = cell.viewWithTag(9) as UILabel
            if let score = ranking[indexPath.row].score {
                scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(score, numberStyle: .DecimalStyle)) Point"
            } else {
                scoreLabel.text = "---"
            }
            scoreLabel.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
}