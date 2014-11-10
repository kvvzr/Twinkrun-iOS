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

class TitleViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            navigationController!.navigationBar.barTintColor = UIColor.twinkrunGreen()
            navigationController!.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font
            ]
            navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        }
        var gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor.twinkrunLightBlack().CGColor,
            UIColor.twinkrunBlack().CGColor
        ]
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

