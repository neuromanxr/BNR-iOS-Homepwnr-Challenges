//
//  BNRItemCell.h
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/7/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

// block
@property (nonatomic, copy) void (^actionBlock)(void);

@end
