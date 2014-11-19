//
//  DEVDeviceCollectionViewCell.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/18/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

class DEVDeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var deviceImageView: UIImageView!
    @IBOutlet var deviceTitle: UILabel!
    
    
    func configureForDevice(currentDevice:DEVDevice)
    {
        deviceImageView.image = currentDevice.deviceImage
        deviceTitle.text      = currentDevice.displayName
    }
}
