//
//  BlockAlertView.h
//  LSATMax
//
//  Created by Jason Loewy on 1/9/14.
//  Copyright (c) 2014 Jason Loewy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlockAlertView;

typedef void(^JLAlertBlock)(BlockAlertView* alertView, NSInteger buttonIndex);

@interface BlockAlertView : UIAlertView <UIAlertViewDelegate>
{
    JLAlertBlock _clickedButtonBlock;
    JLAlertBlock _willDismissBlock;
    JLAlertBlock _didDismissBlock;
}

@property (nonatomic, strong) id<UIAlertViewDelegate> secondaryDelegate;

- (void) setClickedButtonBlock:(JLAlertBlock) clickedButtonBlock;
- (void) setWillDismissBlock:(JLAlertBlock) willDismissBlock;
- (void) setDidDismissBlock:(JLAlertBlock) didDismissBlock;

@end
