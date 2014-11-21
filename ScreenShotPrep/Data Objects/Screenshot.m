//
//  Screenshot.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/7/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#import "Screenshot.h"

@interface Screenshot ()

@property (nonatomic, strong) NSDate*   timestamp;

@end

@implementation Screenshot

#pragma mark - 
#pragma mark - Initialization Methods

- (id) initWithDictionary:(NSDictionary *)initDict
{
    if (self = [super init])
    {
        _fileName = initDict.allKeys[0];
        _screenshot = [UIImage imageWithContentsOfFile:[DataResourceHandler getPathToFile:_fileName inDirectory:NSDocumentDirectory]];
        
        initDict = initDict[_fileName];
        if ([initDict objectForKey:SSTitle])
            _title = initDict[SSTitle];
        
        if ([initDict objectForKey:SSTimestamp])
            _timestamp = initDict[SSTimestamp];
    }

    return self;
}

- (id) initWithImage:(UIImage *)screenshotImage
{
    if (self = [super init])
        _screenshot = screenshotImage;
    
    return self;
}

#pragma mark -
#pragma mark - Accessor Images

- (NSString*) getTimeStamp
{    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    return [formatter stringFromDate:_timestamp];
}

#pragma mark - 
#pragma mark - Storage Methods

- (void) saveScreenshot
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString* saveName       = [NSString stringWithFormat:@"%@",@(timeStamp)];
    if ([saveName rangeOfString:@"."].location != NSNotFound)
        saveName = [saveName substringToIndex:[saveName rangeOfString:@"."].location];
    
    saveName = [saveName stringByAppendingString:@".png"];
    _title   = [_title stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    NSDictionary* savedImageDict = @{saveName : @{@"name" : _title, @"date" : [[NSDate alloc] init]}};
    
    NSMutableArray* savedImages = [[[NSUserDefaults standardUserDefaults] arrayForKey:kSavedImagesKey] mutableCopy];
    [savedImages insertObject:savedImageDict atIndex:0];
    
    [[NSUserDefaults standardUserDefaults] setValue:savedImages forKey:kSavedImagesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString* dirPath   = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath  = [dirPath stringByAppendingPathComponent:saveName];
    [UIImagePNGRepresentation(_screenshot) writeToFile:filePath atomically:YES];
    
    // Save the image to the users photos
    UIImageWriteToSavedPhotosAlbum(_screenshot, nil, nil, nil);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewImageSavedAlert object:nil];
}

- (BOOL) deleteScreenshot
{
    NSString* filePath = [DataResourceHandler getPathToFile:_fileName inDirectory:NSDocumentDirectory];
    NSError* error;
    
    BOOL successful;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        successful = (error) ? NO : YES;
    }
    else
        successful = YES;
    
    // If the deletion was successful then remove it from the userdefaults
    if (successful)
    {
        // Find the index of the screenshot
        NSMutableArray* recentScreenshots = [[[NSUserDefaults standardUserDefaults] arrayForKey:kSavedImagesKey] mutableCopy];
        NSInteger screenshotIdx           = NSNotFound;
        for (NSDictionary* currentScreenshot in recentScreenshots)
        {
            if ([[currentScreenshot.allKeys firstObject] isEqualToString:_fileName])
            {
                screenshotIdx = [recentScreenshots indexOfObject:currentScreenshot];
                break;
            }
            
        }

        if (screenshotIdx != NSNotFound)
        {
            // Remove the screenshot from the persistent storage
            [recentScreenshots removeObjectAtIndex:screenshotIdx];
            [[NSUserDefaults standardUserDefaults] setValue:recentScreenshots forKey:kSavedImagesKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return successful;
}

@end
