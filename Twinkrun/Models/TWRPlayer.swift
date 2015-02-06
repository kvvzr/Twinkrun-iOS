//
//  TWRPlayer.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import CoreBluetooth

class TWRPlayer: NSObject, NSCoding, Equatable {
    let identifier: NSUUID?
    var playWith: Bool, countedScore: Bool
    var name: NSString
    var colorSeed: UInt32, RSSI: Int?
    var score: Int?
    var roles: [TWRRole]?
    var option: TWRGameOption?
    let version = "2.0"
    
    init(playerName: NSString, identifier: NSUUID?, colorSeed: UInt32) {
        self.name = playerName
        self.identifier = identifier
        self.colorSeed = colorSeed % 1024
        self.option = TWROption.sharedInstance.gameOption
        
        playWith = true
        countedScore = false
        
        super.init()
        
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
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        playWith = true
        countedScore = false
        
        if let version = aDecoder.decodeObjectForKey("version") as? String {
            self.name = aDecoder.decodeObjectForKey("name") as NSString
            self.identifier = aDecoder.decodeObjectForKey("identifier") as? NSUUID
            self.colorSeed = UInt32(aDecoder.decodeIntegerForKey("colorSeed"))
            self.score = aDecoder.decodeIntegerForKey("score")
            super.init()
        } else {
            self.name = aDecoder.decodeObjectForKey("playerName") as NSString
            self.colorSeed = UInt32((aDecoder.decodeObjectForKey("colorListSeed") as NSNumber).integerValue)
            super.init()
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeInteger(Int(colorSeed), forKey: "colorSeed")
        if let score = score {
            aCoder.encodeInteger(score, forKey: "score")
        }
        aCoder.encodeObject(version, forKey: "version")
    }
    
    func createRoleList() {
        roles = []
        
        for role in option!.roles {
            for i in 0 ..< role.count {
                roles!.append(role)
            }
        }
        
        roles!.shuffle(colorSeed)
    }
    
    func advertisementData(UUID: CBUUID) -> Dictionary<NSObject, AnyObject> {
        println(splitString(name, bytes: 12) + "," + String(colorSeed))
        return [
            CBAdvertisementDataServiceUUIDsKey: [UUID],
            CBAdvertisementDataLocalNameKey: splitString(name, bytes: 12) + "," + String(colorSeed)
        ]
    }
    
    func previousRole(second: UInt) -> TWRRole? {
        var sec = second % option!.gameTime()
        var progress: UInt = 0
        
        for i in 0 ..< roles!.count {
            let nextLimit = progress + roles![i].time
            if nextLimit > sec {
                return i == 0 ? roles!.last! : roles![i - 1]
            }
            progress = nextLimit
        }
        
        return nil
    }
    
    func currentRole(second: UInt) -> TWRRole {
        var sec = second % option!.gameTime()
        var progress: UInt = 0
        var current: TWRRole?
        
        for i in 0 ..< roles!.count {
            let nextLimit = progress + roles![i].time
            if nextLimit > sec {
                current = roles![i]
                break
            }
            progress = nextLimit
        }
        
        return current!
    }
    
    func nextRole(second: UInt) -> TWRRole? {
        var progress: UInt = 0
       
        for i in 0 ..< roles!.count - 1 {
            let nextLimit = progress + roles![i].time
            if nextLimit > second {
                return roles![i + 1]
            }
            progress = nextLimit
        }
        
        return nil
    }
    
    private func splitString(input: NSString, bytes length: Int) -> NSString {
        var data = input.dataUsingEncoding(NSUTF8StringEncoding)
        
        for i in reverse(0...min(length, data!.length)) {
            if let result:NSString = NSString(data: data!.subdataWithRange(NSRange(location: 0, length: i)), encoding: NSUTF8StringEncoding) {
                if result.length > 0 {
                    return result
                }
            }
        }
        
        return ""
    }
}

func ==(this: TWRPlayer, that: TWRPlayer) -> Bool {
    return this.identifier == that.identifier
}