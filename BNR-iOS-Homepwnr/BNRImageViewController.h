//
//  BNRImageViewController.h
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) UIScrollView *scrollView;

@end
