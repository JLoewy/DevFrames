//
//  DEVDevice.h
//  ScreenShotPrep
//
//  Created by Jason Loewy on 11/13/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

typedef NS_ENUM(NSInteger, DeviceType) {
    
    DeviceTypeiPhone5cBlue,
    
    DeviceTypeiPhone6Black,
    DeviceTypeiPhone6Silver,
    
    DeviceTypeiPhone6PlusBlack,
    DeviceTypeiPhone6PlusSilver,
    
    DeviceTypeiPadAir2LscpBlack,
    DeviceTypeiPadAir2LscpSilver,
    DeviceTypeiPadAir2PrtBlack,
    DeviceTypeiPadAir2PrtSilver,
    
    DeviceTypeiPadMini3Prt,
    DeviceTypeiPadMini3Lscp,
    
    DeviceTypeIPhone5,
    DeviceTypeiPad4,
    DeviceTypeiPadMini,
    DeviceTypeiPhone4,
};

@interface DEVDevice : NSObject

@property (readonly) BOOL isIpadType;

@property (nonatomic, strong, readonly) NSString* displayName;
@property (nonatomic, strong, readonly) UIImage* deviceImage;

@property (readonly) CGFloat bezelWidth, bezelHeight;

@property (nonatomic, readonly) DeviceType currentType;

/**
 *  Responsible for initializing a DEVDevice type for a specific DeviceType
 *
 *  @param deviceType The DeviceType that this object will be initialized for
 *
 *  @return an initialized DEVDevice object 
 */
+ (DEVDevice*) forDevice:(DeviceType) deviceType;

@end
