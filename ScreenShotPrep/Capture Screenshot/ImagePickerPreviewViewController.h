//
//  ImagePickerPreviewViewController.h
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/12/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

typedef NS_ENUM(NSInteger, ImageEditOption)
{
    ImageEditOptionXPosition,
    ImageEditOptionYPosition,
    ImageEditOptionWidth,
    ImageEditOptionHeight
};

@class Screenshot;
@class DEVDevice;

@interface ImagePickerPreviewViewController : UIViewController

/**
 *  Responsible for configuring the displays data prior to display
 *
 *  @param deviceType The DEVDevice type that will feed the UI of this display
 */
- (void) configureForDevice:(DEVDevice*) deviceType;

- (void) displayForRecent:(Screenshot*) recentScreenshot;

@end
