//
//  InsetView.m
//  My Track
//
//  Created by Jason Loewy on 12/31/12.
//  Copyright (c) 2012 Jason Loewy. All rights reserved.
//

#import "InsetView.h"

@implementation InsetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:Color(100, 100, 100, 1.0)];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Drawing code
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* topShadow = [UIColor blackColor];
    CGSize topShadowOffset = CGSizeMake(0.1, 2.1);
    CGFloat topShadowBlurRadius = 6.5;
    UIColor* bottomShadow = [UIColor blackColor];
    CGSize bottomShadowOffset = CGSizeMake(0.1, -2.1);
    CGFloat bottomShadowBlurRadius = topShadowBlurRadius;
    
    //// topShadowView Drawing
    UIBezierPath* topShadowViewPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, -1, CGRectGetWidth(rect), 1)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, topShadowOffset, topShadowBlurRadius, topShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [topShadowViewPath fill];
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    topShadowViewPath.lineWidth = 1;
    [topShadowViewPath stroke];
    
    
    //// bottomShadowView Drawing
    UIBezierPath* bottomShadowViewPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, CGRectGetHeight(rect) + 1, CGRectGetWidth(rect), 1)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, topShadowOffset, topShadowBlurRadius, topShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [bottomShadowViewPath fill];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, bottomShadowOffset, bottomShadowBlurRadius, bottomShadow.CGColor);
    [[UIColor blackColor] setStroke];
    bottomShadowViewPath.lineWidth = 1;
    [bottomShadowViewPath stroke];
    CGContextRestoreGState(context);
}

@end
