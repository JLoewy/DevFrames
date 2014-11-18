//
//  PreviewSettingsViewController.h
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/16/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//


@class PreviewSettingsViewController;

@protocol PreviewSettingsDelegate <NSObject>

- (void) previewSettings:(PreviewSettingsViewController*) previewSettings didChangeAspectMode:(UIViewContentMode) aspectStyle;
- (void) previewSettings:(PreviewSettingsViewController*) previewSettings didChangeScale:(NSInteger) aspectScale;
- (void) previewSettings:(PreviewSettingsViewController*) previewSettings changedName:(NSString*) imageName;

@end

@interface PreviewSettingsViewController : UITableViewController

// Current Setting Values
@property UIViewContentMode aspectStyle;
@property NSInteger aspectScale;
@property (nonatomic, strong) NSString* outputName;

@property (nonatomic, strong) id<PreviewSettingsDelegate> delegate;

//+ (UIViewContentMode) getAspectMode:(UIViewContentMode) aspectStyle;

@end
