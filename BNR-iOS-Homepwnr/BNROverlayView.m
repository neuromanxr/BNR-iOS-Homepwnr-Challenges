//
//  BNROverlayView.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 7/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNROverlayView.h"

// gold challenge ch11

@implementation BNROverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.opaque = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // Drawing code
    CGRect bounds = self.bounds;
    
    // figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(center.x, center.y)];
    [path addLineToPoint:CGPointMake((center.x / 2), center.y)];
//    [path addLineToPoint:CGPointMake((center.x * 1.5), center.y)];
//    [path addLineToPoint:CGPointMake(center.x, (center.y / 5))];
    path.lineWidth = 2;
    [[UIColor redColor] setStroke];
    [path stroke];
    
    // save the current graphics context
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    
    // restore the current graphics context after gradient
    CGContextRestoreGState(currentContext);
}


@end
