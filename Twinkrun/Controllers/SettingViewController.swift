//
//  SettingViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/23.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//


import UIKit
import CoreBluetooth

enum SettingType {
    case Input(defaultValue: String, onChange: String)
    case Select(title: String, defaultValue: String, values: [String], onChange: (String, TWROption) -> Void)
    case PushView(title: String, onSelect: UINavigationController -> Void)
}

class SettingViewController: UITableViewController, UITextFieldDelegate {
    var option: TWROption?
    var settings: [String: [SettingType]]?
    
    override func viewWillAppear(animated: Bool) {
        option = TWROption.sharedInstance
        settings = [
            "Player Name": [
                SettingType.Input(defaultValue: option!.playerName, onChange: "onChangePlayerName:")
            ],
            "Help": [
                /*SettingType.PushView(title: "Introduction", { navigationController in
                }),*/
                SettingType.PushView(title: "License", onSelect: { navigationController in
                    let path = NSBundle.mainBundle().pathForResource("Pods-acknowledgements", ofType: "plist")
                    navigationController.pushViewController(VTAcknowledgementsViewController(acknowledgementsPlistPath: path)!, animated: true)
                })
            ]
        ]
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.twinkrunBlack()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let settings = settings {
            return settings.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let settings = settings {
            let key = Array(settings.keys)[section]
            return settings[key]!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let settings = settings {
            return Array(settings.keys)[section]
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        cell.selectedBackgroundView = view
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view is UITableViewHeaderFooterView {
            let header = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = UIColor.twinkrunLightBlack()
            header.textLabel!.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = Array(settings!.keys)[indexPath.section]
        let setting = settings![key]![indexPath.row]
        
        switch setting {
        case .Input(defaultValue: let value, onChange: let onChange):
            let cell = tableView.dequeueReusableCellWithIdentifier("inputCell")! as UITableViewCell
            
            cell.backgroundColor = UIColor.twinkrunBlack()
            cell.selectionStyle = .None
            
            let field = cell.viewWithTag(1) as! UITextField
            field.attributedPlaceholder = NSAttributedString(
                string: "Player Name",
                attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.5)]
            )
            field.tintColor = UIColor.twinkrunGreen()
            field.textColor = UIColor.whiteColor()
            field.text = value
            field.delegate = self
            field.addTarget(self, action: Selector(onChange), forControlEvents: UIControlEvents.EditingChanged)
            
            return cell
        case .Select(title: _, defaultValue: _, values: _, onChange: _):
            let cell = UITableViewCell()
            return cell
        case .PushView(title: let title, onSelect: _):
            let cell = UITableViewCell()
            
            cell.backgroundColor = UIColor.twinkrunBlack()
            cell.tintColor = UIColor.whiteColor()
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.textLabel!.text = title
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = Array(settings!.keys)[indexPath.section]
        let setting = settings![key]![indexPath.row]
        
        switch setting {
        case .Input(defaultValue: _, onChange: _):
            break
        case .Select(title: _, defaultValue: _, values: _, onChange: _):
            break
        case .PushView(title: _, onSelect: let onSelect):
            onSelect(navigationController!)
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func onChangePlayerName(textField: UITextField) {
        option!.playerName = textField.text!
        NSUserDefaults.standardUserDefaults().setObject(option!.playerName, forKey: "playerName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}