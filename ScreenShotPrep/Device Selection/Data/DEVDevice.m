//
//  DEVDevice.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/13/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

#import "DEVDevice.h"

@implementation DEVDevice

#pragma mark - 
#pragma mark - Initialization Methods

- (id) initForDevice:(DeviceType) deviceType
{
    if (self = [super init])
    {
        NSLog(@"SCREEN BOUNDS: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
        
        const CGFloat bezelHeightMultiplier = (CGRectGetHeight([UIScreen mainScreen].bounds) / 667.0f);
        const CGFloat bezelWidthMultiplier  = (CGRectGetWidth([UIScreen mainScreen].bounds)  / 375.0f);
        
#warning Temporary defaults
        _bezelWidth  = _bezelHeight = 0.0f;
        
        _isIpadType  = NO;
        _currentType = deviceType;
        switch (deviceType) {
            case DeviceTypeiPhone6Black:
            case DeviceTypeiPhone6Silver:
            {
                NSString* imageName = (deviceType == DeviceTypeiPhone6Silver) ? @"iPhone6PrtSlv" : @"iPhone6PrtBlack";
                
                _deviceImage = [UIImage imageNamed:imageName];
                _displayName = @"iPhone 6";
                _bezelWidth  = 36;
                _bezelHeight = 135;
                break;
            }
            case DeviceTypeiPhone6PlusBlack:
            {
                NSString* imageName = (deviceType == DeviceTypeiPhone6PlusSilver) ? @"iPhone6+Slv" : @"iPhone6+Black";
                _displayName = @"iPhone 6+";
                _deviceImage = [UIImage imageNamed:imageName];
                _bezelWidth  = 32;
                _bezelHeight = 118;
                break;
            }
            case DeviceTypeiPadAir2LscpBlack:
            case DeviceTypeiPadAir2LscpSilver:
            case DeviceTypeiPadAir2PrtBlack:
            case DeviceTypeiPadAir2PrtSilver:
                
                _bezelHeight = 140;
                _bezelWidth  = 80;
                _isIpadType  = YES;
                _displayName = @"iPad Air 2";
                if (deviceType == DeviceTypeiPadAir2LscpBlack)
                    _deviceImage = [UIImage imageNamed:@"iPadAir2LandscapeBlck"];
                else if (deviceType == DeviceTypeiPadAir2LscpSilver)
                    _deviceImage = [UIImage imageNamed:@"iPadAir2LanscapeSlv"];
                else if (deviceType == DeviceTypeiPadAir2PrtBlack)
                    _deviceImage = [UIImage imageNamed:@"iPadAir2PrtBlck"];
                else if (deviceType == DeviceTypeiPadAir2PrtSilver)
                    _deviceImage = [UIImage imageNamed:@"iPadAir2PrtSlv"];
                
                break;
                
            case DeviceTypeiPadMini3Lscp:
                _isIpadType  = YES;
                _displayName = @"iPad Mini Retina";
                _deviceImage = [UIImage imageNamed:@"iPadMini3LandscapeBlack"];
                break;
            case DeviceTypeiPadMini3Prt:
                
                _bezelHeight = 96;
                _bezelWidth  = 34;
                _isIpadType  = YES;
                _displayName = @"iPad Mini Retina";
                _deviceImage = [UIImage imageNamed:@"iPadMini3VertBlack"];
                break;
            case DeviceTypeiPad4:
                
                _bezelHeight = 134;
                _bezelWidth  = 110;
                
                _isIpadType  = YES;
                _displayName = @"iPad 4";
                _deviceImage = [UIImage imageNamed:@"iPad4"];
                break;
            case DeviceTypeiPadMini:
                
                _bezelWidth  = 34;
                _bezelHeight = 96;
                
                _isIpadType  = YES;
                _displayName = @"iPad Mini";
                _deviceImage = [UIImage imageNamed:@"iPadMini"];
                break;
            case DeviceTypeiPhone4:
                _displayName = @"iPhone 4s";
                _deviceImage = [UIImage imageNamed:@"iPhone4s"];
                break;
            case DeviceTypeIPhone5:
                
                _bezelWidth  = 34;
                _bezelHeight = 128;
                _displayName = @"iPhone 5s";
                _deviceImage = [UIImage imageNamed:@"iPhone5"];
                break;
            case DeviceTypeiPhone5cBlue:
                
                _bezelWidth  = 34;
                _bezelHeight = 128;
                _displayName = @"iPhone 5c";
                _deviceImage = [UIImage imageNamed:@"iPhone5cBlue"];
                break;
            default:
                _displayName = @"";
                _deviceImage = [UIImage imageNamed:@""];
                break;
        }
        
        _bezelWidth  *= bezelWidthMultiplier;
        _bezelHeight *= bezelHeightMultiplier;
    }
    
    return self;
}

+ (DEVDevice*) forDevice:(DeviceType)deviceType
{
    return [[DEVDevice alloc] initForDevice:deviceType];
}

@end