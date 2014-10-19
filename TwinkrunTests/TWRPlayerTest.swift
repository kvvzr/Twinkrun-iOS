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

    func testExample() {
        var option = TWROption.sharedInstance.gameOption
        var player = TWRPlayer(playerName: "mactkg", identifier: nil, colorSeed:1024)
        player.createRoleList()
        
        XCTAssertNotNil(player, "playerある")
        XCTAssertEqual(player.playerName, "mactkg", "指定した名前になってる")
        XCTAssertTrue(player.colorSeed < 1024, "colorSeedは1024未満")
        XCTAssertTrue(player.currentRole(0 % option.gameTime()).dynamicType === TWRRole.self, "TWRRoleが返ってくる")
        XCTAssertTrue(player.currentRole(8 % option.gameTime()).dynamicType === TWRRole.self, "TWRRoleが返ってくる")
        XCTAssertTrue(player.currentRole(option.gameTime()).dynamicType === TWRRole.self, "TWRRoleが返ってくる")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
