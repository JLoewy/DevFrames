//
//  ImagePickerPreviewViewController.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/12/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ScreenShotPrep-Swift.h"

/// Associated View Controllers
#import "ImagePickerPreviewViewController.h"
#import "PreviewSettingsViewController.h"

/// Data Object Imports
#import "DEVDevice.h"
#import "Screenshot.h"

/// UI Objects
#import "BlockAlertView.h"

@interface ImagePickerPreviewViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

// Data Objects
@property BOOL fromRecent;
@property ImageEditOption currentEditOption;
@property (nonatomic, strong) DEVDevice* deviceType;
@property (nonatomic, strong) Screenshot* activeScreenshot;

// Image Output Objects
@property UIViewContentMode aspectStyle;
@property NSInteger aspectScale;

// UI Objets
@property (strong, nonatomic) IBOutlet LayeredDeviceView *screenshotContainer;
@property (nonatomic, strong) UIImagePickerController* pickerController;

// Image Editing Objects
@property (strong, nonatomic) IBOutlet UIStepper          *editStepper;
@property (strong, nonatomic) IBOutlet UIToolbar          *editParentToolbar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *editTypeSegmentedControl;
@property NSInteger currentValue;
@property (strong, nonatomic) IBOutlet UISegmentedControl *deltaSegmentedController;

@end

@implementation ImagePickerPreviewViewController

#pragma mark -
#pragma mark - Initialization Methods

- (void) configureForDevice:(DEVDevice *)deviceType
{
    _deviceType = deviceType;
}

- (void) displayForRecent:(Screenshot *)recentScreenshot
{
    _activeScreenshot = recentScreenshot;
    _fromRecent       = YES;
}

#pragma mark - 
#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentValue = _editStepper.value;
    
    _aspectStyle = UIViewContentModeScaleAspectFit;
    _aspectScale = (!isIpad && _deviceType.isIpadType) ? 4.0 : 2.0;
    
    if (_activeScreenshot == NULL)
    {
        [_screenshotContainer configureForDevice:_deviceType];
    }
    else if (_fromRecent)
    {
        //----
        // Enter here if there is an active screenshot at this point
        // That means that the user is review a previously saved screenshot
        //----
        [_screenshotContainer configureFromSavedScreenshot:_activeScreenshot];
    }
    
    if (!isIpad)
    {
        [_deltaSegmentedController removeFromSuperview];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (!_fromRecent)
    {
        if (_pickerController == NULL)
        {
            // Enter here to present the image picker to the user on the first time this view controller displays
            _pickerController = [[UIImagePickerController alloc] init];
            [_pickerController setDelegate:self];
            [_pickerController setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum)];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self presentViewController:_pickerController animated:YES completion:nil];
            });
        }
        else if (_activeScreenshot == nil)
        {
            // Enter here if the user failed to pick a screenshot when the image picker was displayed
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

/**
 *  Responsible for reacting to the back button being selected and dismissing this page from view
 *
 *  @param sender The object responsible for firing this method
 */
- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark - Screenshot Adjustment Methods

/**
 *  Responsible for reacting to the user changing the value of the currently selected ImagEditOption
 *
 *  @param sender The UIStepper that was tapped to call this function
 */
- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    CGFloat delta;
    
    // Base the delta value off of the current selected segment of the delta segmented controllers
    switch (_deltaSegmentedController.selectedSegmentIndex) {
        case 0:
            delta = 1;
            break;
        case 1:
            delta = 2;
            break;
        case 2:
            delta = 5;
            break;
        default:
            delta = 1;
            break;
    }
    
    if (sender.value < _currentValue)
        delta *= -1;
    
    [_screenshotContainer manipulateScreenshot:_currentEditOption delta:delta];
    _currentValue = sender.value;
}

/**
 *  Updates the currently selected ImageEditing option based off of which segment is now selected
 *
 *  @param sender The object that is responsible for firing this method
 */
- (IBAction)segmentedControllerChanged:(UISegmentedControl *)sender
{
    _editStepper.value = _currentValue = 0.0f;
    switch (sender.selectedSegmentIndex) {
        case 0:
            _currentEditOption = ImageEditOptionXPosition;
            break;
        case 1:
            _currentEditOption = ImageEditOptionYPosition;
            break;
        case 2:
            _currentEditOption = ImageEditOptionWidth;
            break;
        case 3:
            _currentEditOption = ImageEditOptionHeight;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - Share Methods

/**
 *  Responsible for reacting to the user signifying that they want to share this screenshot. Asks the user if they want to save or email this screenshot
 *
 *  @param sender The UIBarButintItem that was tapped to call this function
 */
- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender
{
    UIActionSheet* shareSheet;
    if (!_fromRecent)
        shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share Screenshot" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Save", nil];
    else
        shareSheet = [[UIActionSheet alloc] initWithTitle:@"Share Screenshot" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", nil];
    
    [shareSheet showInView:self.navigationController.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        // Present the user with the title text input alert
        BlockAlertView* titleAlert = [[BlockAlertView alloc] initWithTitle:@"Enter Image Title" message:@"Enter your desired title, or skip to bypass naming your screenshot." delegate:nil cancelButtonTitle:@"Skip" otherButtonTitles:@"Save", nil];
        [titleAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [titleAlert setDidDismissBlock:^(BlockAlertView *alertView, NSInteger alertButtonIndex) {
            
            NSString* titleText;
            if (alertButtonIndex != alertView.cancelButtonIndex && [alertView textFieldAtIndex:0].text.length > 0)
                titleText = [alertView textFieldAtIndex:0].text;
            
            if ([[actionSheet buttonTitleAtIndex:buttonIndex] containsString:@"Email"])
            {
                [self emailScreenshot:titleText];
            }
            else if ([[actionSheet buttonTitleAtIndex:buttonIndex] containsString:@"Save"])
            {
                [self saveScreenshot:titleText];
            }
        }];
        
        [titleAlert show];
    }
}

/**
 *  Resposnible for retrieving a image representation of the layered device view
 *
 *  @param completionBlock The block of code that will get called when retrieval of the image represetiation is complete
 */
static NSDateFormatter *__nameDateFormatter;
- (void) retrieveImage:(void(^)(Screenshot*)) completionBlock
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Hide all of the surrounding views besides the layered device image
        _editParentToolbar.alpha = self.navigationController.navigationBar.alpha = 0.0f;
        [self.view setBackgroundColor:[UIColor clearColor]];
        
    }completion:^(BOOL finished){
        
        [self.view setBackgroundColor:[UIColor clearColor]];
        
        // Save the actual image
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, _aspectScale);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSMutableString* screenshotName;
        if (_activeScreenshot.title.length > 0)
            screenshotName = [_activeScreenshot.title mutableCopy];
        else
        {
            // If there wasnt an explicit title provided then initialize one based off of the time
            if (__nameDateFormatter == nil)
            {
                // Only need to initialize the date formatter onces
                __nameDateFormatter = [[NSDateFormatter alloc] init];
                [__nameDateFormatter setTimeStyle:NSDateFormatterFullStyle];
            }
            
            screenshotName = [NSMutableString stringWithFormat:@"Dev Frames %@",[__nameDateFormatter stringFromDate:[[NSDate alloc] init]]];
            [screenshotName replaceOccurrencesOfString:@"/" withString:@":" options:NSLiteralSearch range:(NSRange){0,screenshotName.length}];
            
            for (NSString* needle in @[@"PM", @"AM"])
            {
                NSRange range = [screenshotName rangeOfString:needle];
                if (range.location != NSNotFound)
                {
                    [screenshotName deleteCharactersInRange:(NSRange){range.location, (screenshotName.length - range.location)}];
                    break;
                }
            }
        }
        
        // Make sure that it has the correct file extention on it
        if (![screenshotName containsString:@".png"])
            [screenshotName appendString:@".png"];
        
        if (completionBlock)
        {
            Screenshot* newScreenshot = [[Screenshot alloc] initWithImage:viewImage];
            [newScreenshot setTitle:screenshotName];
            
            completionBlock(newScreenshot);
        }
        
        // Bring back all of the faded UI Objects
        [UIView animateWithDuration:1.0 animations:^{
            [self.view setBackgroundColor:[UIColor darkGrayColor]];
            _editParentToolbar.alpha = self.navigationController.navigationBar.alpha = 1.0f;
        }];
    }];
    
}

/**
 *  REsponsible for saving the image to the users persistent local storage
 *
 *  @param sender The object responsible for firing this method
 */
- (IBAction)saveScreenshot:(NSString*) title
{
    [self retrieveImage:^(Screenshot *newScreenshot) {
        
        if (title.length > 0)
            [newScreenshot setTitle:title];
        
        [newScreenshot saveScreenshot];
        [[[UIAlertView alloc] initWithTitle:@"Image Saved" message:@"Your screenshot was successfully saved for later use." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
        
    }];
}

/**
 * Responsible for generating the screenshot and presenting the mail composer.  Called when the user selects that they wish to email the screenshot
 *
 * @param sender The object responsible for firing this method
 */
- (IBAction)emailScreenshot:(NSString*) title
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
        [mfViewController setMailComposeDelegate:self];
        
        NSDateFormatter* timestampFormatter = [[NSDateFormatter alloc] init];
        [timestampFormatter setDateStyle:NSDateFormatterMediumStyle];
        [mfViewController setSubject:[NSString stringWithFormat:@"Dev Frames %@", [timestampFormatter stringFromDate:[[NSDate alloc] init]]]];
        
        [self retrieveImage:^(Screenshot *currentScreenshot) {
            
            if (title.length > 0)
                [currentScreenshot setTitle:title];
            
            NSData* imageData  = UIImagePNGRepresentation(currentScreenshot.screenshot);
            NSString* fileName = currentScreenshot.title;
            
            if (![fileName containsString:@".png"])
                fileName = [fileName stringByAppendingString:@".png"];
            
            [mfViewController addAttachmentData:imageData mimeType:@"image/png" fileName:fileName];
            
            [self presentViewController:mfViewController animated:YES completion:nil];
        }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Mail Error" message:@"Your mail client is not configured with any accounts" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show];
    }
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 
#pragma mark - UIImagePickerController Delegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _activeScreenshot  = [[Screenshot alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];
    [_screenshotContainer configureForScreenshot:_activeScreenshot];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end