//
//  TWRGame.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreBluetooth

enum TWRGameState {
    case Idle
    case CountDown
    case Stated
}

protocol TWRGameDelegate {
    func didUpdateCountDown(count: UInt)
    func didStartGame(game: TWRGame)
    func didUpdateScore(game: TWRGame)
    func didFlash(game: TWRGame)
    func didUpdateRole(game: TWRGame)
    func didEndGame(game: TWRGame)
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
    
    var centralManager: CBCentralManager
    var peripheralManager: CBPeripheralManager
    
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
    }
    
    func start() {
        transition = []
        currentTransition = []
        score = option.startScore
        flashCount = 0
        countDown = option.countTime
        
        scanTimer = NSTimer(timeInterval: 1, target: self, selector: "countDown", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(scanTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func countDown(timer: NSTimer) {
        state = TWRGameState.CountDown
        delegate?.didUpdateCountDown(countDown!)
        
        if countDown! == 0 {
            timer.invalidate()
            
            state = TWRGameState.Stated
            delegate?.didStartGame(self)
            delegate?.didUpdateRole(self)
            startTime = NSDate()
            var current = UInt(NSDate().timeIntervalSinceDate(startTime!) / 1000)
            
            updateRoleTimer = NSTimer(timeInterval: Double(player.currentRole(current).time), target: self, selector: "updateRole", userInfo: nil, repeats: true)
            updateScoreTimer = NSTimer(timeInterval: Double(option.scanInterval), target: self, selector: "updateScore", userInfo: nil, repeats: true)
            flashTimer = NSTimer(timeInterval: Double(option.flashStartTime(player.currentRole(current).time)), target: self, selector: "flash", userInfo: nil, repeats: true)
            gameTimer = NSTimer(timeInterval: Double(option.gameTime()), target: self, selector: "end", userInfo: nil, repeats: true)
            
            NSRunLoop.mainRunLoop().addTimer(updateRoleTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(updateScoreTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
            NSRunLoop.mainRunLoop().addTimer(gameTimer!, forMode: NSRunLoopCommonModes)
        }
        
        --countDown!
    }
    
    func updateRole(timer: NSTimer) {
        var current = UInt(NSDate().timeIntervalSinceDate(startTime!) / 1000)
        transition! += [(role: player.currentRole(current), scores: currentTransition!)]
        
        flashCount = 0
        currentTransition = []
        
        delegate?.didUpdateRole(self)
        
        updateRoleTimer = NSTimer(timeInterval: Double(player.currentRole(current).time), target: self, selector: "updateRole", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(updateRoleTimer!, forMode: NSRunLoopCommonModes)
        
        flashTimer = NSTimer(timeInterval: Double(option.flashStartTime(player.currentRole(current).time)), target: self, selector: "flash", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func updateScore(timer: NSTimer) {
        currentTransition!.append(score)
        addScore = 0
        
        for player in others {
            player.countedScore = false
        }
        
        delegate?.didUpdateScore(self)
    }
    
    func flash(timer: NSTimer) {
        if (flashCount < option.flashCount) {
            delegate?.didFlash(self)
            self.flashTimer = NSTimer(timeInterval: Double(option.flashInterval()), target: self, selector: "flash", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(flashTimer!, forMode: NSRunLoopCommonModes)
        }
        
        ++flashCount!
    }
    
    func end() {
        scanTimer?.invalidate()
        updateRoleTimer?.invalidate()
        updateScoreTimer?.invalidate()
        flashTimer?.invalidate()
        gameTimer?.invalidate()
    }
    
    func end(timer: NSTimer) {
        end()
        delegate?.didEndGame(self)
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        var current = UInt(NSDate().timeIntervalSinceDate(startTime!) / 1000)
        var findPlayer = TWRPlayer(advertisementData: advertisementData, identifier: peripheral.identifier)
        
        var other = others.filter { $0 == findPlayer }
        if !other.isEmpty {
            other[0].RSSI = RSSI.integerValue;
            
            if other[0].playWith && !other[0].countedScore {
                addScore -= Int(/**/ player.currentRole(current).score)
                addScore += Int(/*TODO： 距離によってスコアを変える */ other[0].currentRole(current).score)
            }
        }
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
    }
}