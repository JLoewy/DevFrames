//
//  AppDelegate.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/7/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#import "AppDelegate.h"
#import "ScreenShotPrep-Swift.h"

#import "RecentShotsViewController.h"

@implementation AppDelegate

- (void) applyTheme
{    
    [[UINavigationBar appearance] setBarTintColor:Color(240, 240, 240, 1.0f)];
    [[UINavigationBar appearance] setTintColor:Color(40, 40, 40, 1.0f)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Semibold" size:22], NSForegroundColorAttributeName : Color(60, 60, 60, 1.0f)}];
    [[UIBarButtonItem appearance]  setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0f], NSForegroundColorAttributeName : Color(60, 60, 60, 1.0f)} forState:UIControlStateNormal];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self applyTheme];
//    [self showAllFonts];
    
    // Create the initial data store for the saved images
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kSavedImagesKey])
    {
        [[NSUserDefaults standardUserDefaults] setValue:[@[] mutableCopy] forKey:kSavedImagesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return YES;
}

/*
 Output all of the system fonts to the console
 */
- (void) showAllFonts
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        
        
        NSLog(@"Family name: %@ (%ld)", [familyNames objectAtIndex:indFamily], fontNames.count);
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
