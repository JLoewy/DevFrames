//
//  DEVDeviceSelectionCollectionViewController.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/18/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

let reuseIdentifier = "Device-Cell"
let deviceTypes = [DEVDevice.forDevice(.TypeiPhone6Black), DEVDevice.forDevice(.TypeiPhone6PlusBlack), DEVDevice.forDevice(DeviceType.TypeiPadAir2PrtBlack), DEVDevice.forDevice(.TypeiPadMini3Prt), DEVDevice.forDevice(.TypeIPhone5), DEVDevice.forDevice(.TypeiPhone5cBlue), DEVDevice.forDevice(.TypeiPad4), DEVDevice.forDevice(.TypeiPadMini)]

class DEVDeviceSelectionCollectionViewController: UICollectionViewController {
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.collectionViewLayout = DeviceLayout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Present-Image-Picker"
        {
            let imagePickerController = (segue.destinationViewController as! UINavigationController).viewControllers[0]as! ImagePickerPreviewViewController
            
            let index:Int = Int(self.collectionView!.contentOffset.x / CGRectGetWidth(self.collectionView!.bounds))
            imagePickerController.configureForDevice(deviceTypes[index])
        }
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int { return 1 }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return deviceTypes.count }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)as! DEVDeviceCollectionViewCell
        cell.configureForDevice(deviceTypes[indexPath.row])
        
        return cell
    }
}

// MARK: - Flow Layout Implementation

class DeviceLayout : UICollectionViewFlowLayout {
    
    var layoutInfo = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        
        let collectionViewBounds = CGRectGetWidth(self.collectionView!.bounds)
        for i in 0...(deviceTypes.count - 1)
        {
            let currentLayoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forRow: i, inSection: 0))
            currentLayoutAttribute.frame = CGRectMake(collectionViewBounds * CGFloat(i), 0, collectionViewBounds, CGRectGetHeight(self.collectionView!.bounds))
            
            layoutInfo.append(currentLayoutAttribute)
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return layoutInfo[indexPath.row]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        for currentAttribute in layoutInfo
        {
            if CGRectIntersectsRect(rect, currentAttribute.frame) {
                attributes.append(currentAttribute)
            }
        }
        
        return attributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSizeMake(CGRectGetWidth(self.collectionView!.bounds) * CGFloat(deviceTypes.count), (CGRectGetHeight(self.collectionView!.bounds) - 100.0));
    }
    
}