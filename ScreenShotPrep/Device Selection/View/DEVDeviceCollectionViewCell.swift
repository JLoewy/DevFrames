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
    
    /**
    Responsible for configuring the UI of the collection view cell
    
    :param: currentDevice the DEVDevice that is being displayed on this cell
    */
    func configureForDevice(currentDevice:DEVDevice)
    {
        deviceImageView.image = currentDevice.deviceImage
        deviceTitle.text      = currentDevice.displayName
    }
}
