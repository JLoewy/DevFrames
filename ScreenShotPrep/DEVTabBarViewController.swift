//
//  DEVTabBarViewController.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/15/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

class DEVTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the bg color view to the tab bar
        let bgView             = UIView(frame: tabBar.bounds)
        bgView.backgroundColor = UIColor(red: CGFloat(230.0/255.0), green: CGFloat(230.0/255.0), blue: CGFloat(230.0/255.0), alpha: 1.0)
        tabBar.insertSubview(bgView, atIndex: 0)
        
        // Vertically center the images
        if let tabBarItems = tabBar.items as? [UITabBarItem]{
            
            for currentItem in tabBarItems {
                currentItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
            }
        }
    }
}
