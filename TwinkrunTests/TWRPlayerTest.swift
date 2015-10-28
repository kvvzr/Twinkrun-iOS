//
//  TWRPlayerTest.swift
//  Twinkrun
//
//  Created by Kenta Hara on 10/17/14.
//  Copyright (c) 2014 Twinkrun. All rights reserved.
//

import UIKit
import XCTest
import CoreBluetooth

class TWRPlayerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRole() {
        let player = TWRPlayer(playerName: "kwzr", identifier: nil, colorSeed: 0)
        player.roles = [
            TWRRole.red(count: 4, time: 3, score: -10),
            TWRRole.green(count: 3, time: 3, score: 20),
            TWRRole.black(count: 3, time: 3, score: 0),
            TWRRole.red(count: 4, time: 3, score: -10),
            TWRRole.green(count: 3, time: 3, score: 20),
            TWRRole.black(count: 3, time: 3, score: 0),
            TWRRole.red(count: 4, time: 3, score: -10),
            TWRRole.green(count: 3, time: 3, score: 20),
            TWRRole.black(count: 3, time: 3, score: 0),
            TWRRole.red(count: 4, time: 3, score: -10)
        ]
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.previousRole(0)!)
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.currentRole(0))
        XCTAssert(TWRRole.green(count: 3, time: 3, score: 20) == player.nextRole(0)!)
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.previousRole(3)!)
        XCTAssert(TWRRole.green(count: 3, time: 3, score: 20) == player.currentRole(3))
        XCTAssert(TWRRole.black(count: 3, time: 3, score: 0) == player.currentRole(6))
        XCTAssert(TWRRole.black(count: 3, time: 3, score: 0) == player.previousRole(27)!)
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.currentRole(27))
        XCTAssert(player.nextRole(27) == nil)
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.previousRole(30)!)
        XCTAssert(TWRRole.red(count: 4, time: 3, score: -10) == player.currentRole(30))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
