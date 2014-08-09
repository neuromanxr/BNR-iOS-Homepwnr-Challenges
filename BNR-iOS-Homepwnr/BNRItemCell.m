//
//  BNRItemCell.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/7/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
