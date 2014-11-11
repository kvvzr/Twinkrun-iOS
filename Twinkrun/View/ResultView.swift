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
            UIColor.twinkrunLightBlack().CGColor,
            UIColor.twinkrunBlack().CGColor
        ]
        layer.insertSublayer(gradient!, atIndex: 0)
        layer.cornerRadius = 4
        clipsToBounds = true
        
        if let result = result {
            var graph = viewWithTag(2)! as BEMSimpleLineGraphView
            graph.enablePopUpReport = true
            graph.colorBackgroundXaxis = UIColor.whiteColor()
            graph.colorTop = UIColor.clearColor()
            graph.colorBottom = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            graph.colorLine = UIColor.whiteColor()
            graph.delegate = result
            graph.dataSource = result
            addSubview(graph)
            
            let gesture = UITapGestureRecognizer(target: self, action: Selector("onTaped:"))
            addGestureRecognizer(gesture)
            
            var dateLabel = viewWithTag(3) as UILabel
            dateLabel.text = result.dateText()
            
            var scoreLabel = viewWithTag(4) as UILabel
            scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(result.score, numberStyle: .DecimalStyle)) Point"
        }
    }
    
    func onTaped(sender: UITapGestureRecognizer) {
    }
}