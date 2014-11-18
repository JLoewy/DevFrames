//
//  DEVDeviceSelectionPageViewController.swift
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/13/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

import UIKit

class DEVDeviceSelectionPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let deviceTypes = [DEVDevice.forDevice(.TypeiPhone6Black), DEVDevice.forDevice(.TypeiPhone6PlusBlack), DEVDevice.forDevice(DeviceType.TypeiPadAir2PrtBlack), DEVDevice.forDevice(.TypeiPadMini3Prt), DEVDevice.forDevice(.TypeIPhone5), DEVDevice.forDevice(.TypeiPhone5cBlue), DEVDevice.forDevice(.TypeiPad4), DEVDevice.forDevice(.TypeiPadMini)]
    var currentPage = 0
    
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
    }
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate   = self
        view.backgroundColor = UIColor(red: CGFloat(240.0/255.0), green: CGFloat(240.0/255.0), blue: CGFloat(240.0/255.0), alpha: CGFloat(1.0))
        
        self.setViewControllers([viewControllerAtIndex(currentPage)], direction: .Forward, animated: false, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Present-Image-Picker"
        {
            let imagePickerController = (segue.destinationViewController as UINavigationController).viewControllers[0] as ImagePickerPreviewViewController
            
            if let currentDeviceController: DEVDeviceViewController = self.viewControllers.last as? DEVDeviceViewController {
                imagePickerController.configureForDevice(deviceTypes[currentDeviceController.pageIdx]);
            }
        }
    }
    
    // MARK: - PageViewController Delegate/Datasource

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as DEVDeviceViewController).pageIdx
        if (index == NSNotFound) || ((index + 1) >= countElements(deviceTypes)) { return nil; }
        
        return viewControllerAtIndex(++index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as DEVDeviceViewController).pageIdx
        
        if (index <= 0) || (index == NSNotFound) { return nil; }
        
        return viewControllerAtIndex(--index);
    }
    
    func viewControllerAtIndex(index:Int)->UIViewController
    {
        let deviceViewController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewControllerWithIdentifier("Device-Type-View-Controller") as DEVDeviceViewController
        
        let currentDevice            = deviceTypes[index]
        currentPage                  = index
        deviceViewController.pageIdx = index
        deviceViewController.configureForDeviceType(currentDevice)
        
        return deviceViewController
    }
}
