//
//  TWRPlayer.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreBluetooth

class TWRPlayer : Equatable {
    let identifier: NSUUID?
    var playWith: Bool, countedScore: Bool
    var name: NSString
    var colorSeed: UInt32, RSSI: Int?
    var roles: [TWRRole]?
    var option: TWRGameOption
    
    init(playerName: NSString, identifier: NSUUID?, colorSeed: UInt32) {
        self.name = playerName
        self.identifier = identifier
        self.colorSeed = colorSeed % 1024
        self.option = TWROption.sharedInstance.gameOption
        
        playWith = true
        countedScore = false
        
        createRoleList()
    }
    
    init(advertisementDataLocalName: String, identifier: NSUUID) {
        var data: [String] = advertisementDataLocalName.componentsSeparatedByString(",")
        
        self.name = data[0]
        self.colorSeed = UInt32(data[1].toInt()!)
        self.identifier = identifier
        self.option = TWROption.sharedInstance.gameOption
        
        playWith = true
        countedScore = true
    }
    
    func createRoleList() {
        roles = []
        
        for role in option.roles {
            for i in 0 ..< role.count {
                roles!.append(role)
            }
        }
        
        roles!.shuffle(colorSeed)
    }
    
    func advertisementData(UUID: CBUUID) -> Dictionary<NSObject, AnyObject> {
        return [
            CBAdvertisementDataServiceUUIDsKey: [UUID],
            CBAdvertisementDataLocalNameKey: splitString(name, bytes: 12) + "," + String(colorSeed)
        ]
    }
    
    func currentRole(second: UInt) -> TWRRole {
        if(roles == nil) {
            createRoleList()
        }
        var sec = second % option.gameTime()
        var progress: UInt = 0
        var current: TWRRole?
        
        for role in roles! {
            let nextLimit = progress + role.time
            if nextLimit > sec {
                current = role
                break
            }
            progress = nextLimit
        }
        
        return current!
    }
    
    func nextRole(second: UInt) -> TWRRole? {
        var progress: UInt = 0
       
        for(var i = 0; i < roles!.count-1; i++) {
            let nextLimit = progress + roles![i].time
            if nextLimit > second {
                return roles![i+1]
            }
            progress = nextLimit
        }
        
        return nil
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