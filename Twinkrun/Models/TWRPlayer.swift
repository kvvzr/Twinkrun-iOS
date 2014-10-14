//
//  TWRPlayer.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreBluetooth

class TWRPlayer {
    let identifier: NSUUID
    var playWith: Bool, countedScore: Bool
    var playerName: NSString
    var colorSeed: UInt32, RSSI: Int?
    var colors: [TWRColor]?
    var option: TWRGameOption
    
    init(playerName: NSString, identifier: NSUUID, colorSeed: UInt32, option: TWRGameOption) {
        self.playerName = playerName
        self.identifier = identifier
        self.colorSeed = colorSeed
        self.option = option
        
        playWith = true
        countedScore = false
        
        createColorList()
    }
    
    init(advertisementData: Dictionary<NSObject, Any>, identifier: NSUUID, option: TWRGameOption) {
        var data: [String] = (advertisementData["kCBAdvDataLocalName"] as String).componentsSeparatedByString(",")
        
        self.playerName = data[0]
        self.colorSeed = UInt32(data[1].toInt()!)
        self.identifier = identifier
        self.option = option
        
        playWith = true
        countedScore = true
    }
    
    func createColorList() {
        colors = []
        
        for color in option.colors {
            for i in 0 ..< color.count {
                colors!.append(color)
            }
        }
        
        colors!.shuffle(colorSeed)
    }
    
    func advertisementData(UUID: CBUUID) -> Dictionary<NSObject, Any> {
        return [
            CBAdvertisementDataServiceUUIDsKey: [UUID],
            CBAdvertisementDataLocalNameKey: splitString(playerName, bytes: 12) + String(colorSeed)
        ]
    }
    
    func currentColor(second: UInt) -> TWRColor {
        var sec = second % option.gameTime()
        var progress: UInt = 0
        var current: TWRColor?
        
        for color in colors! {
            progress += color.time
            if sec > progress {
                current = color
                break
            }
        }
        
        return current!
    }
    
    private func splitString(input: NSString, bytes length: Int) -> NSString {
        var data = input.dataUsingEncoding(NSUTF8StringEncoding)
        
        for i in reverse(0...min(length, data!.length)) {
            var result = NSString(data: data!.subdataWithRange(NSRange(location: 0, length: i)), encoding: NSUTF8StringEncoding)
            if result.length > 0 {
                return result
            }
        }
        
        return ""
    }
}

func ==(this: TWRPlayer, that: TWRPlayer) -> Bool {
    return this.identifier == that.identifier
}