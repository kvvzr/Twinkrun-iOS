//
//  TwinkrunTests.swift
//  TwinkrunTests
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import XCTest

class TwinkrunTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOption() {
        var option = TWROption.sharedInstance
        option.playerName = "WAIWAI"
        
        XCTAssert(TWROption.sharedInstance.playerName == "WAIWAI")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
