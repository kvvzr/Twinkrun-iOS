//
//  TitleViewController.swift
//  Twinkrun
//
//  Created by Kawazure on 2014/10/09.
//  Copyright (c) 2014年 Twinkrun. All rights reserved.
//

import UIKit

extension UINavigationController {
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

class TWRTabBarController: UITabBarController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UITabBar.appearance().barTintColor = UIColor.twinkrunBlack()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.2)], forState: UIControlState.Normal)
        
        UIToolbar.appearance().barTintColor = UIColor.twinkrunBlack()
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}