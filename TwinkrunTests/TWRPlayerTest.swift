//
//  TWRPlayerTest.swift
//  Twinkrun
//
//  Created by Kenta Hara on 10/17/14.
//  Copyright (c) 2014 Twinkrun. All rights reserved.
//

import UIKit
import XCTest
import Twinkrun

class TWRPlayerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlayer() {
        var option = TWROption.sharedInstance.gameOption
        var player = TWRPlayer(playerName: "mactkg", identifier: nil, colorSeed:1024)
        
        XCTAssertNotNil(player, "playerある")
        XCTAssertEqual(player.playerName, "mactkg", "指定した名前になってる")
        XCTAssertTrue(player.colorSeed < 1024, "colorSeedは1024未満")
       
        XCTAssertNotNil(player.currentRole(0), "ちゃんと現在の色が返ってくる")
        XCTAssertNotNil(player.currentRole(16), "ちゃんと現在の色が返ってくる")
        XCTAssertNotNil(player.currentRole(option.gameTime()), "ちゃんと現在の色が返ってくる")
    
        XCTAssertNotNil(player.nextRole(0), "ちゃんと次の色が返ってくる")
        XCTAssert(player.nextRole(0) == player.currentRole(3), "ちゃんと次の色が返ってくる")
        XCTAssert(player.nextRole(5) == player.currentRole(8), "ちゃんと次の色が返ってくる")
        XCTAssertNil(player.nextRole(option.gameTime()-3), "次がおしまいの時はnilが返ってくる")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
