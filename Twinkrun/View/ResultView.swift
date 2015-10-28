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
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func reload() {
        reload(animated: true)
    }
    
    func reload(animated animated: Bool) {
        for sublayer in layer.sublayers! {
            if sublayer is CAGradientLayer {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        
        var gradientColor = UIColor.twinkrunLightBlack()
        if let result = result {
            let rank = result.rank(result.player)
            if rank == 0 {
                gradientColor = UIColor.twinkrunGreen()
            } else if rank == result.others.count {
                gradientColor = UIColor.twinkrunRed()
            }
        }
        
        gradient.colors = [
            UIColor.clearColor(),
            gradientColor.CGColor
        ]
        layer.insertSublayer(gradient, atIndex: 0)
        layer.cornerRadius = 4
        clipsToBounds = true
        
        if let result = result {
            let graph = viewWithTag(2) as! BEMSimpleLineGraphView
            graph.delegate = result
            graph.dataSource = result
            graph.enablePopUpReport = true
            graph.colorBackgroundXaxis = UIColor.whiteColor()
            graph.colorTop = UIColor.clearColor()
            graph.colorBottom = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            graph.colorLine = UIColor.whiteColor()
            graph.colorTouchInputLine = UIColor.whiteColor().colorWithAlphaComponent(0.5)
            if !animated {
                graph.animationGraphStyle = BEMLineAnimation.None
            }
            graph.reloadGraph()
            
            if let view = viewWithTag(7) {
                let rankingTable = view as! RankingView
                rankingTable.result = result
                rankingTable.makeRanking()
                rankingTable.backgroundColor = UIColor.clearColor()
            }
            
            let dateLabel = viewWithTag(3) as! UILabel
            dateLabel.text = result.dateText()
            
            let scoreLabel = viewWithTag(4) as! UILabel
            scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(result.score, numberStyle: .DecimalStyle)) Point"
            
            if let view = viewWithTag(5) {
                let backButton = view as! UIButton
                backButton.addTarget(self, action: Selector("back:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            if let view = viewWithTag(6) {
                let nextButton = view as! UIButton
                nextButton.addTarget(self, action: Selector("next:"), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            if result.focusOnGraph {
                back(nil)
            } else {
                next(nil)
            }
        }
    }
    
    func back(sender: UIButton?) {
        if let view = viewWithTag(5) {
            let backButton = view as! UIButton
            backButton.enabled = false
        }
        
        if let view = viewWithTag(6) {
            let nextButton = view as! UIButton
            nextButton.enabled = true
        }
        
        let graph = viewWithTag(2) as! BEMSimpleLineGraphView
        graph.hidden = false
        
        if let view = viewWithTag(7) {
            let rankingTable = view as! RankingView
            rankingTable.hidden = true
        }
        
        if let result = result {
            result.focusOnGraph = true
        }
    }
    
    func next(sender: UIButton?) {
        if let view = viewWithTag(5) {
            let backButton = view as! UIButton
            backButton.enabled = true
        }
        
        if let view = viewWithTag(6) {
            let nextButton = view as! UIButton
            nextButton.enabled = false
        }
        
        let graph = viewWithTag(2) as! BEMSimpleLineGraphView
        graph.hidden = true
        
        if let view = viewWithTag(7) {
            let rankingTable = view as! RankingView
            rankingTable.hidden = false
        }
        
        if let result = result {
            result.focusOnGraph = false
        }
    }
}