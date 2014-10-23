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
    var brightness: CGFloat?
    
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
        tableView.separatorInset = UIEdgeInsetsZero
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
        return 320
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.respondsToSelector(Selector("separatorInset")) {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector(Selector("layoutMargins")) {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("separatorInset")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("layoutMargins")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as UITableViewCell
        
        cell.backgroundColor = UIColor.twinkrunBlack()
        var graph:BEMSimpleLineGraphView = cell.viewWithTag(1) as BEMSimpleLineGraphView
        //graph.delegate = result!
        //graph.dataSource = result!
        
        return cell
    }
    
    @IBAction func onClose(sender: UIBarButtonItem) {
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onAction(sender: UIBarButtonItem) {
        let contents = ["I got \(result!.score) points in this game! #twinkrun"]
        let controller = UIActivityViewController(activityItems: contents, applicationActivities: nil)
        controller.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint]
        presentViewController(controller, animated: true, completion: {})
    }
}