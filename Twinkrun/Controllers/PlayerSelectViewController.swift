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
    var player: TWRPlayer?
    var others: [TWRPlayer]?
    var centralManager: CBCentralManager?
    var peripheralManager: CBPeripheralManager?
    var option: TWROption?
    var brightness: CGFloat = 1.0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        centralManager?.delegate = self
        peripheralManager?.delegate = self
        
        navigationController!.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        option = TWROption.sharedInstance
        
        others = []
        brightness = UIScreen.mainScreen().brightness
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.twinkrunBlack()
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        centralManager?.stopScan()
        peripheralManager?.stopAdvertising()
        
        navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return others!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("playerCell") as UITableViewCell
        var other = others![indexPath.row]
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
        let findPlayer = TWRPlayer(advertisementData: advertisementData, identifier: peripheral.identifier)
    
        let other = others!.filter { $0 == findPlayer }
        if other.isEmpty {
            others!.append(findPlayer)
        } else {
            other.first!.playerName = findPlayer.playerName
            other.first!.colorSeed = findPlayer.colorSeed
            other.first!.createRoleList()
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if centralManager?.state == CBCentralManagerState.PoweredOn {
            centralManager!.scanForPeripheralsWithServices(
                [CBUUID.UUIDWithString(option!.advertiseUUID)],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheralManager?.state == CBPeripheralManagerState.PoweredOn {
            peripheralManager!.startAdvertising(
                player!.advertisementData(CBUUID.UUIDWithString(option!.advertiseUUID))
            )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "matchSegue" {
            
        }
    }
}