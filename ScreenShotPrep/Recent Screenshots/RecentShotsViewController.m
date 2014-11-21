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
        // Perform the initial recent screenshot retrieval and add the observer to react to new saved screenshtos
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"No-Saved-Id"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RecentImageSelected"] && [segue.destinationViewController isKindOfClass:[UINavigationController class]])
    {
        // Enter here to prepare the image picker to display the recent screenshot that was tapped
        ImagePickerPreviewViewController* prevVC = [((UINavigationController*)segue.destinationViewController).viewControllers firstObject];
        Screenshot* selectedShot                 = _recentShots[[self.tableView indexPathForSelectedRow].row];
        [prevVC displayForRecent:selectedShot];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(_recentShots.count, 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //----
    // Check the exit conditions for if there is no recent screenshots saved
    // This means that it should go to the default screenshot
    //----
    if (_recentShots.count == 0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"No-Saved-Id" forIndexPath:indexPath];
        [cell.textLabel setFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0f]];
        [cell.textLabel setText:@"No Saved Screenshots"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    // Create the standard recent screenshot cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentShotCell" forIndexPath:indexPath];
    Screenshot* currentScreenshot = _recentShots[indexPath.row];
    
    [cell.imageView setImage:currentScreenshot.screenshot];
    [cell.textLabel setText:currentScreenshot.title];
    [cell.detailTextLabel setText:[currentScreenshot getTimeStamp]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (_recentShots.count > 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_recentShots.count > 0)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            // Delete the image from the users documents directory
            Screenshot* screenshotToDelete = _recentShots[indexPath.row];
            if ([screenshotToDelete deleteScreenshot])
            {
                // Update the table content and display
                [_recentShots removeObjectAtIndex:indexPath.row];
                if (_recentShots.count > 0)
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                else
                    [tableView reloadData];
            }
            else
            {
                UIAlertView* deleteError = [[UIAlertView alloc] initWithTitle:@"Delete Error" message:@"We're sorry, there was an error when trying to delete this screenshot" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                [deleteError show];
            }
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (_recentShots.count > 0) ? 60.0f : 44.0f;
}

@end
