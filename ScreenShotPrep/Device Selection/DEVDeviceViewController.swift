//
//  DEVDeviceViewController.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/13/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

class DEVDeviceViewController: UIViewController {

    // MARK: - Data Objects
    var currentDevice:DEVDevice!
    var pageIdx = -1
    
    // MARK: - UI Objects
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var deviceImageView: UIImageView!
    
    // MARK: - Initialization Methods
    
    func configureForDeviceType(currentDevice:DEVDevice)
    {
        self.currentDevice = currentDevice
    }
    
    // MARK: - View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        nameLabel.text            = currentDevice.displayName
        deviceImageView.image     = currentDevice.deviceImage
    }
}
