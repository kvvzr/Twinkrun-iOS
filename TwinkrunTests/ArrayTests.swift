//
//  ArrayTests.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit
import XCTest

class ArrayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testQueue() {
        var queue = [1]
        queue.append(2)
        XCTAssertEqual(queue, [1, 2])
        
        var one = queue.dequeue()!
        XCTAssertEqual(one, 1)
        
        queue.dequeue()
        XCTAssertEqual(queue, [])
        
        queue.dequeue()
        XCTAssertEqual(queue, [])
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
