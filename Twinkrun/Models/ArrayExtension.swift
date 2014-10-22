//
//  ArrayExtension.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import Foundation

extension Array {
    mutating func dequeue() -> T? {
        return count > 0 ? removeAtIndex(0) : nil
    }
    
    mutating func shuffle() {
        for _ in 0 ..< count {
            sort {(_, _) in arc4random() % 2 == 0}
        }
    }
    
    mutating func shuffle(seed: UInt32) {
        srand(seed)
        for _ in 0 ..< count {
            sort {(_, _) in rand() % 2 == 0}
        }
    }
}
