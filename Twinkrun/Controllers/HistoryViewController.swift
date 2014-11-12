//
//  HistoryViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/23.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import CoreBluetooth

class HistoryViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    var resultData: [TWRResult]?
    var toolbar: UIToolbar?
    var selectedRows: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            navigationController!.navigationBar.barTintColor = UIColor.twinkrunGreen()
            navigationController!.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font
            ]
            navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        }
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIView()
        tableView.backgroundView!.backgroundColor = UIColor.twinkrunBlack()
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        toolbar = UIToolbar(frame: tabBarController!.tabBar.frame)
        toolbar!.backgroundColor = UIColor.twinkrunBlack()
        toolbar!.items = [
            UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("onAction:")),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: Selector("onDelete:"))
        ]
        toolbar!.hidden = true
        tabBarController!.tabBar.superview!.addSubview(toolbar!)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsPath.stringByAppendingPathComponent("TWRResultData2")
        resultData = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [TWRResult]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let resultData = resultData {
            return resultData.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("resultCell") as UITableViewCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView.backgroundColor = UIColor.clearColor()
        
        var view = cell.viewWithTag(1)! as ResultView
        view.result = resultData![indexPath.row]
        view.reload()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRows.removeObject(indexPath.row)
        
        if let toolbar = toolbar {
            (toolbar.items!.first! as UIBarButtonItem).enabled = (selectedRows.count == 1)
        }
        
        if selectedRows.count == 0 {
            tabBarController!.tabBar.hidden = false
            
            if let toolbar = toolbar {
                toolbar.hidden = true
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRows.append(indexPath.row)
        
        if selectedRows.count > 0 {
            tabBarController!.tabBar.hidden = true
            
            if let toolbar = toolbar {
                toolbar.hidden = false
                (toolbar.items!.first! as UIBarButtonItem).enabled = (selectedRows.count == 1)
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !editing {
            tabBarController!.tabBar.hidden = false
            
            if let toolbar = toolbar {
                toolbar.hidden = true
            }
        }

        selectedRows = []
    }
    
    func onDelete(sender: UIBarButtonItem) {
        var indexPaths: [NSIndexPath] = []
        
        sort(&selectedRows, {$0 > $1})
        for row in selectedRows {
            indexPaths.append(NSIndexPath(forRow: row, inSection: 0))
            resultData!.removeAtIndex(row)
        }
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let path = documentsPath.stringByAppendingPathComponent("TWRResultData2")
        NSKeyedArchiver.archiveRootObject(resultData!, toFile: path)
        
        self.setEditing(false, animated: true)
    }
    
    func onAction(sender: UIBarButtonItem) {
        for row in selectedRows {
            let result = resultData![row]
            let view = UIView(frame: CGRectMake(0, 0, 320, 224))
            view.backgroundColor = UIColor.twinkrunBlack()
            var resultView = UINib(nibName: "ShareBoard", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ResultView
            resultView.frame = CGRectMake(0, 0, 320, 244)
            resultView.result = result
            resultView.reload(animated: false)
            view.addSubview(resultView)
            let image = viewToImage(view)
            let contents = ["I got \(result.score) points in this game! #twinkrun", image]
            let controller = UIActivityViewController(activityItems: contents, applicationActivities: nil)
            controller.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypePostToFlickr, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint]
            presentViewController(controller, animated: true, completion: {})
        }
        
        self.setEditing(false, animated: true)
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