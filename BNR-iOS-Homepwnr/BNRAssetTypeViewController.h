//
//  BNRAssetTypeViewController.h
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/13/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DismissDelegate <NSObject>

- (void)didTap;

@end

@class BNRItem;

@interface BNRAssetTypeViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, assign) id <DismissDelegate> delegate;

@property (nonatomic, strong) BNRItem *item;

@end
