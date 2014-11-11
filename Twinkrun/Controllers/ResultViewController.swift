//
//  ResultViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/23.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import CoreBluetooth

class ResultViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var result: TWRResult?
    
    override init() {
        super.init(style: UITableViewStyle.Plain)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.twinkrunBlack()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        tableView.layoutIfNeeded()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsPath.stringByAppendingPathComponent("TWRResultData2")
        var data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [TWRResult]
        if (data == nil) {
            data = []
        }
        data!.append(result!)
        data!.sort({$0.date.timeIntervalSinceNow > $1.date.timeIntervalSinceNow})
        
        NSKeyedArchiver.archiveRootObject(data!, toFile: path)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as UITableViewCell
        
        cell.backgroundColor = UIColor.twinkrunBlack()
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        var view = cell.viewWithTag(1)!
        
        var roleCount = result!.roles.count
        var graphColor = result!.score < 1000 ? UIColor.twinkrunRed() : UIColor.twinkrunGreen()
        var gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            graphColor.colorWithAlphaComponent(0.2).CGColor,
            graphColor.CGColor
        ]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var graph:BEMSimpleLineGraphView = cell.viewWithTag(2) as BEMSimpleLineGraphView
            
            graph.delegate = self.result
            graph.dataSource = self.result
            
            graph.enablePopUpReport = true
            graph.colorBackgroundXaxis = UIColor.whiteColor()
            graph.colorTop = UIColor.clearColor()
            graph.colorBottom = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            graph.colorLine = UIColor.whiteColor()
        })
        
        var dateLabel = cell.viewWithTag(3) as UILabel
        dateLabel.text = result!.dateText()
        
        var scoreLabel = cell.viewWithTag(4) as UILabel
        scoreLabel.text = "\(NSNumberFormatter.localizedStringFromNumber(result!.score, numberStyle: .DecimalStyle)) Point"
        
        return cell
    }
    
    @IBAction func onClose(sender: UIBarButtonItem) {
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onAction(sender: UIBarButtonItem) {
        let image = viewToImage(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!)
        let contents = ["I got \(result!.score) points in this game! #twinkrun", image]
        let controller = UIActivityViewController(activityItems: contents, applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint]
        presentViewController(controller, animated: true, completion: {})
    }
    
    func viewToImage(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.mainScreen().scale)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}