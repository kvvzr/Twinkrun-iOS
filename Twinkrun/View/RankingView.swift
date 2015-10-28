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
        super.init(coder: aDecoder)!
        
        delegate = self
        dataSource = self
        backgroundView = nil
        backgroundColor = UIColor.twinkrunBlack()
        tableFooterView = UIView(frame: CGRectZero)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
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
            ranking!.sortInPlace({ $0.score > $1.score })
            ranking! += tmp.filter({ $0.score == nil })
            reloadData()
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
            let header = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = UIColor.twinkrunLightBlack()
            header.textLabel!.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell")! as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        if let ranking = ranking {
            let nameLabel = cell.viewWithTag(8) as! UILabel
            nameLabel.text = ranking[indexPath.row].name as String
            nameLabel.textColor = UIColor.whiteColor()
            
            let scoreLabel = cell.viewWithTag(9) as! UILabel
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