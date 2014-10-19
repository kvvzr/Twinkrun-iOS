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

    func testPlayer() {
        func test(player:TWRPlayer, cbUUID:CBUUID) -> Bool {
            var option = TWROption.sharedInstance.gameOption
            XCTAssertNotNil(player, "playerある")
            XCTAssertTrue(player.colorSeed < 1024, "colorSeedは1024未満")
           
            XCTAssertNotNil(player.currentRole(0), "ちゃんと現在の色が返ってくる")
            XCTAssertNotNil(player.currentRole(16), "ちゃんと現在の色が返ってくる")
            XCTAssertNotNil(player.currentRole(option.gameTime()), "ちゃんと現在の色が返ってくる")
        
            XCTAssertNotNil(player.nextRole(0), "ちゃんと次の色が返ってくる")
            XCTAssert(player.nextRole(0) == player.currentRole(3), "ちゃんと次の色が返ってくる")
            XCTAssert(player.nextRole(5) == player.currentRole(8), "ちゃんと次の色が返ってくる")
            XCTAssertNil(player.nextRole(option.gameTime()-3), "次がおしまいの時はnilが返ってくる")
       
            let advData = player.advertisementData(cbUUID)
            let nameKey:String = advData[CBAdvertisementDataLocalNameKey] as NSString
            let playerUUID = (advData[CBAdvertisementDataServiceUUIDsKey] as NSArray).firstObject as CBUUID
            XCTAssert(nameKey == "\(player.playerName),\(player.colorSeed)", "正しい配信情報を返してくれる")
            XCTAssert(playerUUID == cbUUID, "UUIDが一致する")
            
            return true
        }
        
        let uuid = NSUUID(UUIDString: "eddbfbac-57af-11e4-a09f-7831c1d35942")
        let cbUUID = CBUUID.UUIDWithString("0e15d2fc-57ac-11e4-a8ea-7831c1d35942")
        var player = TWRPlayer(playerName: "mactkg", identifier: uuid, colorSeed:1024)
        XCTAssert(test(player, cbUUID), "普通のプレイヤーでうまくいく")
       
        let advData = player.advertisementData(cbUUID)
        let nameKey:String = advData[CBAdvertisementDataLocalNameKey] as NSString
        var remotePlayer = TWRPlayer(advertisementData:["kCBAdvDataLocalName": nameKey], identifier: uuid)
        XCTAssert(test(remotePlayer, cbUUID), "複製してもうまくいく")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
