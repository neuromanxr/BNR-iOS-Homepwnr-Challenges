//
//  BNRDetailViewController.h
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 7/3/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

// BNRDetailViewController will populate its text fields with the properties of BNRItem
// passing this data from BNRItemsViewController to BNRDetailViewController
@class BNRItem;

@interface BNRDetailViewController : UIViewController

// check whether instance is being used to create a new BNRItem or show existing
- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic, strong) BNRItem *item;

@end
