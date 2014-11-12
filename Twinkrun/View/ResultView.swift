//
//  ResultView.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/11/11.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit

class ResultView: UIView {
    var result: TWRResult?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func reload() {
        var gradient = CAGradientLayer()
        gradient!.frame = self.bounds
        
        gradient!.colors = [
            UIColor.twinkrunLightBlack().colorWithAlphaComponent(0.2).CGColor,
            UIColor.twinkrunLightBlack().CGColor
        ]
        layer.insertSublayer(gradient!, atIndex: 0)
        layer.cornerRadius = 4
        clipsToBounds = true
        
        if let result = result {
            var graph = viewWithTag(2) as BEMSimpleLineGraphView
            graph.enablePopUpReport = true
            graph.colorBackgroundXaxis = UIColor.whiteColor()
            graph.colorTop = UIColor.clearColor()
            graph.colorBottom = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            graph.colorLine = UIColor.whiteColor()
            graph.delegate = result
            graph.dataSource = result
            addSubview(graph)
            
            var rankingTable = viewWithTag(7) as RankingView
            rankingTable.result = result
            rankingTable.makeRanking()
            rankingTable.backgroundColor = UIColor.clearColor()
            
            var dateLabel = viewWithTag(3) as UILabel
            dateLabel.text = result.dateText()
            
            var scoreLabel = viewWithTag(4) as UILabel
            scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(result.score, numberStyle: .DecimalStyle)) Point"
            
            var backButton = viewWithTag(5) as UIButton
            backButton.addTarget(self, action: Selector("back:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            var nextButton = viewWithTag(6) as UIButton
            nextButton.addTarget(self, action: Selector("next:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func back(sender: UIButton) {
        var backButton = viewWithTag(5) as UIButton
        backButton.enabled = false
        
        var nextButton = viewWithTag(6) as UIButton
        nextButton.enabled = true
        
        var graph = viewWithTag(2) as BEMSimpleLineGraphView
        graph.hidden = false
        
        var rankingTable = viewWithTag(7) as RankingView
        rankingTable.hidden = true
    }
    
    func next(sender: UIButton) {
        var backButton = viewWithTag(5) as UIButton
        backButton.enabled = true
        
        var nextButton = viewWithTag(6) as UIButton
        nextButton.enabled = false
        
        var graph = viewWithTag(2) as BEMSimpleLineGraphView
        graph.hidden = true
        
        var rankingTable = viewWithTag(7) as RankingView
        rankingTable.hidden = false
    }
}