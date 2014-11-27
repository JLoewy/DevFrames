//
//  LayeredDeviceView.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/14/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

class LayeredDeviceView: UIView, UIGestureRecognizerDelegate {
    
    var forceScreenshotLayout = false
    
    let deviceImageView     = UIImageView()
    let screenshotImageView = UIImageView()
    var bezelWidth  = 20.0
    var bezelHeight = 100.0
    
    var originalScreenCenter:CGPoint?
    
    // MARK:- Configuration Methods
    
    /**
    Responsible for setting up the screenshot image view to display the newly provided Screenshots image
    
    :param: screenshot The Screenshot object that is responsible for feeding this objects display
    */
    func configureForScreenshot(screenshot:Screenshot)
    {
        screenshotImageView.image = screenshot.screenshot
        forceScreenshotLayout     = true
        setNeedsLayout()
    }
    
    /**
    Responsible for setting up the device view for the currently active device type. Sets up the corresponding UIImageView
    
    :param: currentDevice The DEVDevice that is being worked with
    */
    func configureForDevice(currentDevice:DEVDevice)
    {
        deviceImageView.image = currentDevice.deviceImage
        bezelWidth            = Double(currentDevice.bezelWidth)
        bezelHeight           = Double(currentDevice.bezelHeight)
        deviceImageView.reloadInputViews()
        
//        currentDevice.getSomething()
    }
    
    /**
    Responsible for configure the display to show the saved screenshot that the user selected
    
    :param: savedSCreenshot The saved Screenshot object that the user wants to review
    */
    func configureFromSavedScreenshot(savedSCreenshot:Screenshot)
    {
        deviceImageView.image = savedSCreenshot.screenshot
        screenshotImageView.removeFromSuperview()
        setNeedsLayout()
    }
    
    // MARK:- View LIfecycle Functions
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        backgroundColor                 = UIColor.clearColor()
        deviceImageView.contentMode     = .ScaleAspectFit
        deviceImageView.image           = UIImage(named: "iPhone5cBlue")
        screenshotImageView.contentMode = .ScaleToFill
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        panGestureRecognizer.delegate = self
        screenshotImageView.addGestureRecognizer(panGestureRecognizer)
        screenshotImageView.userInteractionEnabled = true
        
        self.addSubview(deviceImageView)
        self.addSubview(screenshotImageView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        deviceImageView.frame = self.bounds
        
        // Auto layout the screenshot image view based off of how the device image falls in the view
        if forceScreenshotLayout
        {
            if let deviceImage = deviceImageView.image {
                
                var imageHeight      = deviceImage.size.height
                var imageWidth       = deviceImage.size.width
                let imageAspectRatio = (imageHeight / imageWidth)
                
                let parentHeight = deviceImageView.bounds.size.height
                let parentWidth  = deviceImageView.bounds.size.width
                
//                if (parentHeight < imageHeight)
//                {
                    imageHeight = parentHeight
                    imageWidth  = (imageHeight / imageAspectRatio)
//                }
                
                let xSpace = fabs((parentWidth - imageWidth) + CGFloat(bezelWidth))
                let ySpace = fabs((parentHeight - imageHeight) + CGFloat(bezelHeight))
                
                imageHeight = parentHeight - ySpace;
                imageWidth  = parentWidth  - xSpace;
                
                screenshotImageView.frame  = CGRectMake(xSpace/2, ySpace/2, imageWidth, imageHeight)
                screenshotImageView.center = CGPointMake(deviceImageView.center.x, deviceImageView.center.y - 1)
                
                forceScreenshotLayout = false
            }
        }
    }
    
    // MARK: - Pan Gesture Methods
    
    func handlePan(recognizer:UIPanGestureRecognizer)
    {
        if recognizer.state == .Began {
            originalScreenCenter = screenshotImageView.center
        }
        else if recognizer.state == .Changed {
            
            if let originalCenter = originalScreenCenter {
                
                let translation = recognizer.translationInView(self)
                let newCenter = CGPointMake(originalCenter.x + translation.x, originalCenter.y + translation.y)
                if (newCenter.x - (CGRectGetWidth(screenshotImageView.bounds) / 2) > 0 && (newCenter.y - (CGRectGetHeight(screenshotImageView.bounds) / 2)) > 0)
                {
                    screenshotImageView.center = newCenter
                }
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Image Manipulation Methods
    
    /**
    Responsible for manipulating the image view that holds the screenshot
    
    :param: editOptionType The type of editing that will take place
    :param: delta          The value of the change that will take place to the screenshot image
    */
    func manipulateScreenshot(editOptionType:ImageEditOption, delta:CGFloat)-> Void
    {
        switch editOptionType
        {
        case .XPosition:
            screenshotImageView.frame = CGRectMake(screenshotImageView.frame.origin.x + delta, screenshotImageView.frame.origin.y, CGRectGetWidth(screenshotImageView.frame), CGRectGetHeight(screenshotImageView.frame))
            
        case .YPosition:
            screenshotImageView.frame = CGRectMake(screenshotImageView.frame.origin.x, screenshotImageView.frame.origin.y + delta, CGRectGetWidth(screenshotImageView.frame), CGRectGetHeight(screenshotImageView.frame))
            
        case .Width:
            screenshotImageView.frame = CGRectMake(screenshotImageView.frame.origin.x, screenshotImageView.frame.origin.y, (CGRectGetWidth(screenshotImageView.frame) + delta), CGRectGetHeight(screenshotImageView.frame))
            
        case .Height:
            screenshotImageView.frame = CGRectMake(screenshotImageView.frame.origin.x, screenshotImageView.frame.origin.y, CGRectGetWidth(screenshotImageView.frame), (CGRectGetHeight(screenshotImageView.frame) + delta))
        }
    }
}
