//
//  TWROptions.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func twinkrunRed() -> UIColor {
        return UIColor(red: CGFloat(1), green: CGFloat(0.255), blue: CGFloat(0.2), alpha: CGFloat(1))
    }
    
    class func twinkrunGreen() -> UIColor {
        return UIColor(red: CGFloat(0), green: CGFloat(0.81), blue: CGFloat(0.686), alpha: CGFloat(1))
    }
    
    class func twinkrunBlack() -> UIColor {
        return UIColor(red: CGFloat(0.2), green: CGFloat(0.204), blue: CGFloat(0.22), alpha: CGFloat(1))
    }
}

class TWRRole: NSObject, NSCoding, Hashable {
    let name: NSString
    let count: UInt, time: UInt, score: Float
    let color: UIColor
    let version = "2.0"
    
    init(name: NSString, color: UIColor, count: UInt, time: UInt, score: Float) {
        self.name = name
        self.color = color
        self.count = count
        self.time = time
        self.score = score
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as NSString
        self.color = aDecoder.decodeObjectForKey("color") as UIColor
        self.count = UInt(aDecoder.decodeIntegerForKey("count"))
        self.time = UInt(aDecoder.decodeIntegerForKey("time"))
        self.score = aDecoder.decodeFloatForKey("score")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(color, forKey: "color")
        aCoder.encodeInteger(Int(count), forKey: "count")
        aCoder.encodeInteger(Int(time), forKey: "time")
        aCoder.encodeFloat(score, forKey: "score")
    }
    
    class func red(#count: UInt, time: UInt, score: Float) -> TWRRole {
        return TWRRole(name: "Red", color: UIColor.twinkrunRed(), count: count, time: time, score: score)
    }
    
    class func green(#count: UInt, time: UInt, score: Float) -> TWRRole {
        return TWRRole(name: "Green", color: UIColor.twinkrunGreen(), count: count, time: time, score: score)
    }
    
    class func black(#count: UInt, time: UInt, score: Float) -> TWRRole {
        return TWRRole(name: "Black", color: UIColor.twinkrunBlack(), count: count, time: time, score: score)
    }
    
    override var hashValue: Int {
        get {
            return "\(name),\(count),\(time),\(score),\(color)".hashValue
        }
    }
    
    override var description: String {
        return "TWRRole \(name) \(count) \(time) \(score)"
    }
}

func ==(this: TWRRole, that: TWRRole) -> Bool {
    return (
        this.name == that.name &&
        this.count == that.count &&
        this.time == that.time &&
        this.score == that.score &&
        this.color == that.color
    )
}

class TWROption {
    let advertiseUUID = "067AEFE3-371B-4D6D-877E-9C229AFBC33A"
    var playerName = "Twinkrunner"
    var gameOption = TWRGameOption()
    
    class var sharedInstance : TWROption {
        struct Static {
            static let instance : TWROption = TWROption()
        }
        return Static.instance
    }
}

class TWRGameOption {
    var scanInterval: Float = 0.2
    var startScore = 1000
    var flashTime: UInt = 1
    var flashCount: UInt = 4
    var countTime: UInt = 5
    var roles: [TWRRole] = [
        TWRRole.black(count: 3, time: 3, score: 0),
        TWRRole.red(count: 4, time: 3, score: -30),
        TWRRole.green(count: 3, time: 3, score: 80)
    ]
    var randomChange = true
    let version = "2.0"
    
    func gameTime() -> UInt {
        var time: UInt = 0
        for role in roles {
            time += role.count * role.time
        }
        
        return time
    }
    
    func flashStartTime(interval: UInt) -> UInt {
        return interval - flashTime
    }
    
    func flashInterval() -> Float {
        return Float(flashTime) / Float(flashCount)
    }
}
