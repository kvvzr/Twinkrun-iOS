//
//  PlayerSelectViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/14.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import CoreBluetooth

class PlayerSelectViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    @IBOutlet weak var readyButton: UIBarButtonItem!
    var player: TWRPlayer?
    var others: [TWRPlayer]?
    var centralManager: CBCentralManager?
    var peripheralManager: CBPeripheralManager?
    var option: TWROption?
    var brightness: CGFloat = 1.0
    var onMatch = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        if let central = centralManager {
            central.delegate = self
        }
        
        if let peripheral = peripheralManager {
            peripheral.delegate = self
        }
        
        onMatch = false
        
        readyButton.enabled = false
        
        option = TWROption.sharedInstance
        player = TWRPlayer(playerName: option!.playerName, identifier: nil, colorSeed: arc4random())
        others = []
        brightness = UIScreen.mainScreen().brightness
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        if !onMatch {
            if let central = centralManager {
                if central.state == CBCentralManagerState.PoweredOn {
                    central.stopScan()
                }
            }
            
            if let peripheral = peripheralManager {
                if peripheral.state == CBPeripheralManagerState.PoweredOff {
                    peripheral.stopAdvertising()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let others = others {
            return others.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        readyButton.enabled = false
        for other in others! {
            if other.playWith {
                self.readyButton.enabled = true
                break
            }
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("playerCell") as UITableViewCell
        var other = others![indexPath.row]
        
        cell.backgroundColor = UIColor.twinkrunBlack()
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.text = other.name
        cell.accessoryType = other.playWith ? .Checkmark : .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var other = others![indexPath.row]
        other.playWith = !other.playWith
        
        tableView.reloadData()
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if let localName = advertisementData["kCBAdvDataLocalName"] as AnyObject? as? String {
            let findPlayer = TWRPlayer(advertisementDataLocalName: localName, identifier: peripheral.identifier)
        
            let other = others!.filter { $0 == findPlayer }
            if other.isEmpty {
                others!.append(findPlayer)
            } else {
                other.first!.name = findPlayer.name
                other.first!.colorSeed = findPlayer.colorSeed
                other.first!.createRoleList()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state == CBCentralManagerState.PoweredOn {
            central.scanForPeripheralsWithServices(
                [CBUUID(string: option!.advertiseUUID)],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == CBPeripheralManagerState.PoweredOn {
            peripheral.startAdvertising(
                player!.advertisementData(CBUUID(string: option!.advertiseUUID))
            )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "matchSegue" {
            let controller = segue.destinationViewController as MatchViewController
            controller.player = player
            controller.others = others
            controller.central = centralManager
            controller.peripheral = peripheralManager
            controller.brightness = brightness
            controller.hidesBottomBarWhenPushed = true
            
            onMatch = true
            navigationController!.setNavigationBarHidden(true, animated: true)
        }
    }
}