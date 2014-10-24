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
    weak var central: CBCentralManager?
    weak var peripheral: CBPeripheralManager?
    var brightness: CGFloat?
    var game: TWRGame?
    var audio: OALSimpleAudio?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var swipe = UISwipeGestureRecognizer(target: self, action: Selector("backToPlayerSelect"))
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(swipe)
        
        audio = OALSimpleAudio.sharedInstance()
        audio!.honorSilentSwitch = true
        audio!.preloadEffect("beep.mp3")
        audio!.preloadEffect("count-down.mp3")
        audio!.preloadEffect("score-transition.mp3")
        
        game = TWRGame(player: player!, others: others!, central: central!, peripheral: peripheral!)
        game!.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController!.setNavigationBarHidden(false, animated: animated)
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
        audio!.playEffect("count-down.mp3")
        dispatch_async(dispatch_get_main_queue(), {
            self.countLabel.text = String(count)
        })
    }
    
    func didStartGame() {
        self.countLabel.hidden = true
    }
    
    func didUpdateScore(score: Int) {
        audio!.playEffect("score-transition.mp3", volume: 0.2, pitch: pitch(score), pan: 0.0, loop: false)
    }
    
    func didUpdateRole(color: UIColor, score: Int) {
        audio!.playEffect("score-transition.mp3")
        view.backgroundColor = color
    }
    
    func didFlash(color: UIColor) {
        view.backgroundColor = color
    }
    
    func didEndGame() {
        audio!.stopAllEffects()
        audio!.playEffect("beep.mp3")
        audio!.unloadAllEffects()
        
        if central!.state == CBCentralManagerState.PoweredOn && peripheral!.state == CBPeripheralManagerState.PoweredOff {
            central!.stopScan()
            peripheral!.stopAdvertising()
        }
        
        performSegueWithIdentifier("resultSegue", sender: self)
    }
    
    func pitch(score: Int) -> Float {
        return min(1.0, Float(score) / Float(TWROption.sharedInstance.gameOption.startScore * 2) + 0.3)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resultSegue" {
            let controller = segue.destinationViewController as ResultViewController
            controller.result = TWRResult(player: player!, others: others!, scores: game!.transition!, score: game!.score, option: TWROption.sharedInstance.gameOption)
        }
    }
}