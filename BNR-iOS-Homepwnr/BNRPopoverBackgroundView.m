//
//  BNRPopoverBackgroundView.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
// gold challenge ch17

#import "BNRPopoverBackgroundView.h"

@implementation BNRPopoverBackgroundView

@synthesize arrowDirection;
@synthesize arrowOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        self.arrowDirection = UIPopoverArrowDirectionUp;
        self.arrowOffset = 5.0;
    }
    return self;
}

+ (CGFloat)arrowBase
{
    return 10.0;
}

+ (CGFloat)arrowHeight
{
    return 10.0;
}

+ (UIEdgeInsets)contentViewInsets
{
    UIEdgeInsets insets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    return insets;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
