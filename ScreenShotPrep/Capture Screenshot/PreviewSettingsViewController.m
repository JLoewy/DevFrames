/**
 
 CURRENTLY NOT ACTIVE
 
 */

//
//  PreviewSettingsViewController.m
//  ScreenShotPrep
//
//  Created by Jason Loewy on 1/16/13.
//  Copyright (c) 2013 Jason Loewy. All rights reserved.
//

#import "PreviewSettingsViewController.h"

@interface PreviewSettingsViewController ()

@property NSInteger selectedRow;

@property (weak, nonatomic) IBOutlet UITextField *imageName;

@property (weak, nonatomic) IBOutlet UIStepper *scaleStepper;
@property (weak, nonatomic) IBOutlet UILabel *scaleIndicator;

@end

@implementation PreviewSettingsViewController

#pragma mark - 
#pragma mark - UIViewController Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_scaleIndicator setText:[NSString stringWithFormat:@"%ld", _aspectScale]];
    [_scaleStepper setValue:((double) _aspectScale)];
    
    if (_outputName != NULL)
        [_imageName setText:_outputName];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender
{
    if (_imageName.text.length > 0)
        [_delegate previewSettings:self changedName:_imageName.text];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
#pragma mark - Aspect Scale Interaction Methods

- (IBAction)scaleValueChanged:(id)sender
{
    _aspectScale = ((UIStepper*)sender).value;
    [_scaleIndicator setText:[NSString stringWithFormat:@"%ld", _aspectScale]];
    [_delegate previewSettings:self didChangeScale:_aspectScale];
}

#pragma mark - 
#pragma mark - Image Name Interaction Methods

/*
 Responsible for reacting to the submission of the new image name text field
 Responsible for resigning the textfield first responder and calling the delegate method to update the image name
 */
- (IBAction)nameTextFieldDonePressed:(id)sender
{
    [_imageName resignFirstResponder];
}
- (IBAction)nameFieldDone:(id)sender
{
    [_imageName resignFirstResponder];
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0 && _aspectStyle == UIViewContentModeScaleToFill)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            _selectedRow = indexPath.row;
        }
        else if (indexPath.row == 1 && _aspectStyle == UIViewContentModeScaleAspectFit)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            _selectedRow = indexPath.row;
        }
        else if (indexPath.row == 2 && _aspectStyle == UIViewContentModeScaleAspectFill)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            _selectedRow = indexPath.row;
        }
        else
            [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row != _selectedRow)
        {
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:1]] setAccessoryType:UITableViewCellAccessoryNone];
            
            _selectedRow = indexPath.row;
            [_delegate previewSettings:self didChangeAspectMode:_selectedRow];
        }
    }
}

@end
