//
//  TWRGame.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

enum TWRGameState {
    case Idle
    case CountDown
    case Started
}

protocol TWRGameDelegate {
    func didUpdateCountDown(count: UInt)
    func didStartGame()
    func didUpdateScore(score: Int)
    func didFlash(color: UIColor)
    func didUpdateRole(color: UIColor, score: Int)
    func didEndGame()
}

class TWRGame: NSObject, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    var player: TWRPlayer
    var others: [TWRPlayer]
    let option: TWRGameOption
    var state = TWRGameState.Idle
    
    var transition: Array<(role: TWRRole, scores: [Int])>?, currentTransition: [Int]?
    var score: Int, addScore: Int, flashCount: UInt?, countDown: UInt?
    
    var startTime: NSDate?
    var scanTimer: NSTimer?, updateRoleTimer: NSTimer?, updateScoreTimer: NSTimer?, flashTimer: NSTimer?, gameTimer: NSTimer?
    
    unowned var centralManager: CBCentralManager
    unowned var peripheralManager: CBPeripheralManager
    
    var delegate: TWRGameDelegate?
    
    init(player: TWRPlayer, others: [TWRPlayer], central: CBCentralManager, peripheral: CBPeripheralManager) {
        self.player = player
        self.others = others
        self.option = TWROption.sharedInstance.gameOption
        self.centralManager = central
        self.peripheralManager = peripheral
        
        score = option.startScore
        addScore = 0
        
        super.init()
        
        centralManager.delegate = self
        peripheralManager.delegate = self
    }
    
    func start() {
        transition = []
        currentTransition = []
        score = option.startScore
        flashCount = 0
        countDown = option.countTime
        
        scanTimer = NSTimer(timeInterval: 1, target: self, selector: Selector("countDown:"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(scanTimer!, forMode: NSRunLoopCommonModes)
        
        countDown(nil)
    }
    
    func countDown(timer: NSTimer?) {
        state = TWRGameState.CountDown
        
        if countDown! == 0 {
            timer?.invalidate()
            
            state = TWRGameState.Started
            delegate?.didStartGame()
            
            startTime = NSDate()
            var current = UInt(NSDate().timeIntervalSinceDate(startTime!))
            var currentRole = player.currentRole(current)
            
            delegate?.didUpdateRole(currentRole.color, score: score)
            
            updateRoleTimer = NSTimer(timeInterval: Double(currentRole.time), target: self, selector: Selector("updateRole:"), userInfo: nil, repeats: false)
            updateScoreTimer = NSTimer(timeInterval: Double(option.scanInterval), target: self, selector: Selector("updateScore:"), userInfo: nil, repeats: true)
            flashTimer = NSTimer(timeInterval: Double(option.flashStartTime(currentRole.time)), target: self, selector: Selector("flash:"), userInfo: nil, repeats: false)
            gameTimer = NSTimer(timeInterval: Double(option.gameTime()), target: self, selector: Selector("end:"), userInfo: nil, repeats: false)
            
            NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(updateRoleTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(updateScoreTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(gameTimer!, forMode: NSRunLoopCommonModes)
        } else {
            delegate?.didUpdateCountDown(countDown!)
            --countDown!
        }
    }
    
    func updateRole(timer: NSTimer?) {
        var current = UInt(NSDate().timeIntervalSinceDate(startTime!))
        var prevRole = player.previousRole(current)
        var currentRole = player.currentRole(current)
        
        if let prevRole = prevRole {
            transition! += [(role: prevRole, scores: currentTransition!)]
        }
            
        flashCount = 0
        currentTransition = []
        
        delegate?.didUpdateRole(currentRole.color, score: score)
        
        updateRoleTimer = NSTimer(timeInterval: Double(currentRole.time), target: self, selector: Selector("updateRole:"), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(updateRoleTimer!, forMode: NSRunLoopCommonModes)
        
        flashTimer = NSTimer(timeInterval: Double(option.flashStartTime(currentRole.time)), target: self, selector: Selector("flash:"), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func updateScore(timer: NSTimer) {
        currentTransition!.append(score)
        
        score += addScore
        addScore = 0
        
        for player in others {
            player.countedScore = false
        }
        
        delegate?.didUpdateScore(score)
    }
    
    func flash(timer: NSTimer) {
        if (flashCount < option.flashCount) {
            var current = UInt(NSDate().timeIntervalSinceDate(startTime!))
            var nextRole = player.nextRole(current)
            if (nextRole == nil) {
                return
            }
            delegate?.didFlash((flashCount! % 2 == 0 ? player.currentRole(current) : nextRole!).color)
            self.flashTimer = NSTimer(timeInterval: Double(option.flashInterval()), target: self, selector: Selector("flash:"), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
        }
        
        ++flashCount!
    }
    
    func end() {
        if let startTime = startTime {
            var current = UInt(NSDate().timeIntervalSinceDate(startTime))
            var prevRole = player.previousRole(current)!
            
            transition! += [(role: prevRole, scores: currentTransition!)]
            
            currentTransition = []
        }
        
        if let timer: NSTimer = scanTimer {
            timer.invalidate()
        }
        
        if let timer: NSTimer = updateRoleTimer {
            timer.invalidate()
        }
        
        if let timer: NSTimer = updateScoreTimer {
            timer.invalidate()
        }
        
        if let timer: NSTimer = flashTimer {
            timer.invalidate()
        }
        
        if let timer: NSTimer = gameTimer {
            timer.invalidate()
        }
        
        state = TWRGameState.Idle
    }
    
    func end(timer: NSTimer) {
        end()
        delegate?.didEndGame()
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        if let localName = advertisementData["kCBAdvDataLocalName"] as AnyObject? as? String {
            if let startTime = startTime {
                var current = UInt(NSDate().timeIntervalSinceDate(startTime))
                var findPlayer = TWRPlayer(advertisementDataLocalName: localName, identifier: peripheral.identifier)
                
                var other = others.filter { $0 == findPlayer }
                if !other.isEmpty {
                    other.first!.RSSI = RSSI.integerValue
                    if other.first!.playWith && !other.first!.countedScore && RSSI.integerValue <= 0 {
                        var point = pow(1.2, (RSSI.floatValue + 60) / 4)
                        addScore -= Int(point * player.currentRole(current).score)
                        addScore += Int(point * other.first!.currentRole(current).score)
                        other.first!.countedScore = true
                    }
                }
            }
        }
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
    }
}