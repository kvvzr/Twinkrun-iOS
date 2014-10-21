//
//  MatchViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/16.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import CoreBluetooth

class MatchViewController: UIViewController, TWRGameDelegate {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var player: TWRPlayer?
    var others: [TWRPlayer]?
    var central: CBCentralManager?
    var peripheral: CBPeripheralManager?
    var brightness: CGFloat?
    var game: TWRGame?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipe = UISwipeGestureRecognizer(target: self, action: Selector("backToPlayerSelect"))
        
        game = TWRGame(player: player!, others: others!, central: central!, peripheral: peripheral!)
        game!.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func backToPlayerSelect() {
        if game!.state == TWRGameState.Idle {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func didTapedStart(sender: UIButton) {
        if game!.state == TWRGameState.Idle {
            game!.start()
            
            startButton.alpha = 0.1
            startButton.setImage(UIImage(named: "StopMatchButton"), forState: UIControlState.Normal)
            countLabel.hidden = false
        } else {
            game!.end()
            
            startButton.alpha = 1.0
            startButton.setImage(UIImage(named: "StartMatchButton"), forState: UIControlState.Normal)
            
            view.backgroundColor = UIColor.twinkrunBlack()
            countLabel.hidden = true
        }
    }
    
    func didUpdateCountDown(count: UInt) {
        dispatch_async(dispatch_get_main_queue(), {
            self.countLabel.text = String(count)
        })
    }
    
    func didStartGame() {
        self.countLabel.hidden = true
    }
    
    func didUpdateScore(score: Int) {
    }
    
    func didUpdateRole(color: UIColor, score: Int) {
        view.backgroundColor = color
    }
    
    func didFlash(color: UIColor) {
        view.backgroundColor = color
    }
    
    func didEndGame() {
        if central!.state == CBCentralManagerState.PoweredOn && peripheral!.state == CBPeripheralManagerState.PoweredOff {
            central!.stopScan()
            peripheral!.stopAdvertising()
        }
    }
}