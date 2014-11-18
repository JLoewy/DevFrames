//
//  RecentShotsViewController.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/7/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#import "RecentShotsViewController.h"

#import "ImagePickerPreviewViewController.h"

/// Data Objects
#import "Screenshot.h"

@interface RecentShotsViewController ()

@property (nonatomic, strong) NSMutableArray* recentShots;

@end

@implementation RecentShotsViewController

#pragma mark - 
#pragma mark - Initialization Methods

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillContent:) name:kNewImageSavedAlert object:nil];
        [self fillContent:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Initialization Methods

/**
 *  Responsible for fetching all of the local saved screenshots to display
 *
 *  @param notif The NSNotification that coule be responsible for firing this method
 */
- (void) fillContent:(NSNotification*) notif
{
    NSArray* currentSavedImages = [[NSUserDefaults standardUserDefaults] arrayForKey:kSavedImagesKey];
    _recentShots                = [[NSMutableArray alloc] initWithCapacity:currentSavedImages.count];
    
    for (NSDictionary* savedImage in currentSavedImages)
        _recentShots[[currentSavedImages indexOfObject:savedImage]] = [[Screenshot alloc] initWithDictionary:savedImage];
    
    // Only reaload the tableview if this screenshot was saved after the iniitial recentShots fill
    if (notif)
       [self.tableView reloadData];
}

#pragma mark -
#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RecentImageSelected"] && [segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        ImagePickerPreviewViewController* prevVC = [((UINavigationController*)segue.destinationViewController).viewControllers firstObject];
        Screenshot* selectedShot                 = _recentShots[[self.tableView indexPathForSelectedRow].row];
        [prevVC displayForRecent:selectedShot];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return _recentShots.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentShotCell" forIndexPath:indexPath];
    Screenshot* currentScreenshot = _recentShots[indexPath.row];
    
    [cell.imageView setImage:currentScreenshot.screenshot];
    [cell.textLabel setText:currentScreenshot.title];
    [cell.detailTextLabel setText:[currentScreenshot getTimeStamp]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Screenshot* screenshotToDelete = _recentShots[indexPath.row];
        
        // Delete the image from the users documents directory
        if ([DataResourceHandler deleteImageName:[screenshotToDelete getFileName]])
        {
            // Remove the screenshot from the persistent storage
            NSMutableArray* recentScreenshots = [[[NSUserDefaults standardUserDefaults] arrayForKey:kSavedImagesKey] mutableCopy];
            [recentScreenshots removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setValue:recentScreenshots forKey:kSavedImagesKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Update the table content and display
            [_recentShots removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            UIAlertView* deleteError = [[UIAlertView alloc] initWithTitle:@"Delete Error" message:@"We're sorry, there was an error when trying to delete this screenshot" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [deleteError show];
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 60.0f; }

@end
