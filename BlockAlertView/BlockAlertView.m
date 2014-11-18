//
//  BlockAlertView.m
//  LSATMax
//
//  Created by Jason Loewy on 1/9/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

#import "BlockAlertView.h"

@implementation BlockAlertView

#pragma mark - 
#pragma mark - Initialization Methods

// Simple block initialization methods
- (void) setClickedButtonBlock:(JLAlertBlock)clickedButtonBlock
{
    [self setDelegate:self];
    _clickedButtonBlock = clickedButtonBlock;
}

- (void) setWillDismissBlock:(JLAlertBlock)willDismissBlock
{
    [self setDelegate:self];
    _willDismissBlock = willDismissBlock;
}

- (void) setDidDismissBlock:(JLAlertBlock)didDismissBlock
{
    [self setDelegate:self];
    _didDismissBlock = didDismissBlock;
}

#pragma mark -
#pragma mark - Responding Actions

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_clickedButtonBlock != NULL)
        _clickedButtonBlock(self, buttonIndex);
    
    if ([_secondaryDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        [_secondaryDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_willDismissBlock != NULL)
        _willDismissBlock(self, buttonIndex);
    
    if ([_secondaryDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
        [_secondaryDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_didDismissBlock != NULL)
        _didDismissBlock(self, buttonIndex);
    
    if ([_secondaryDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
        [_secondaryDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
}

@end
