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

class SettingViewController: UITableViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var option: TWROption
    let settings: [String: [SettingType]]

    required init(coder aDecoder: NSCoder) {
        option = TWROption.sharedInstance
        settings = [
            "Player Name": [
                SettingType.Input(defaultValue: option.playerName, onChange: "onChangePlayerName:")
            ],
            "Help": [
                SettingType.PushView(title: "Introduction", { navigationController in
                }),
                SettingType.PushView(title: "License", { navigationController in
                    let path = NSBundle.mainBundle().pathForResource("Pods-acknowledgements", ofType: "plist")
                    navigationController.pushViewController(VTAcknowledgementsViewController(acknowledgementsPlistPath: path), animated: true)
                })
            ]
        ]
        
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
        
        tableView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = settings.keys.array[section]
        return settings[key]!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings.keys.array[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var view = UIView()
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        cell.selectedBackgroundView = view
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if view is UITableViewHeaderFooterView {
            var header = view as UITableViewHeaderFooterView
            header.contentView.backgroundColor = UIColor.twinkrunLightBlack()
            header.textLabel.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = settings.keys.array[indexPath.section]
        let setting = settings[key]![indexPath.row]
        
        switch setting {
        case .Input(defaultValue: let value, onChange: let onChange):
            var cell = tableView.dequeueReusableCellWithIdentifier("inputCell") as UITableViewCell
            
            cell.backgroundColor = UIColor.twinkrunBlack()
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            
            var field = cell.viewWithTag(1) as UITextField
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
        case .Select(title: let title, defaultValue: let value, values: let values, onChange: let onChange):
            var cell = UITableViewCell()
            return cell
        case .PushView(title: let title, onSelect: let onSelect):
            var cell = UITableViewCell()
            
            cell.backgroundColor = UIColor.twinkrunBlack()
            cell.layoutMargins = UIEdgeInsetsZero
            cell.separatorInset = UIEdgeInsetsZero
            cell.tintColor = UIColor.whiteColor()
            cell.textLabel.textColor = UIColor.whiteColor()
            cell.textLabel.text = title
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = settings.keys.array[indexPath.section]
        let setting = settings[key]![indexPath.row]
        
        switch setting {
        case .Input(defaultValue: let value, onChange: let onChange):
            break
        case .Select(title: let title, defaultValue: let value, values: let values, onChange: let onChange):
            break
        case .PushView(title: let title, onSelect: let onSelect):
            onSelect(navigationController!)
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func onChangePlayerName(textField: UITextField) {
        option.playerName = textField.text
        NSUserDefaults.standardUserDefaults().setObject(option.playerName, forKey: "playerName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}