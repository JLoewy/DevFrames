//
//  Screenshot.h
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/7/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#define SSTitle     @"name"
#define SSImageName @"fileName"
#define SSTimestamp @"date"

@interface Screenshot : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong, readonly) UIImage* screenshot;

- (id) initWithDictionary:(NSDictionary*) initDict;

/**
 *  Responsible for initializing a new screenshot for the specified image. With this initialization there will be no title or any other information, just the screnshot set
 *
 *  @param screenshotImage The Image that will be live in the Screenshot object
 *
 *  @return An initliazed Screenshot
 */
- (id) initWithImage:(UIImage*) screenshotImage;

- (NSString*) getTimeStamp;
- (NSString*) getFileName;

/**
 *  Responsible for saving the screenshot to persistant storage for later use
 */
- (void) saveScreenshot;

@end
