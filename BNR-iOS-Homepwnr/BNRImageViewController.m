//
//  BNRImageViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    // gold challenge ch19
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
//    imageView.contentMode = UIViewContentModeCenter;
//    self.view = imageView;
    
    self.iv = imageView;
    
    scrollView.contentSize = imageView.bounds.size;
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 10.0;
    [scrollView addSubview:self.iv];
    
    self.view = scrollView;
    
    // gold challenge ch19 end
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // we must cast the view to UIImageView so the compiler knows it
    // is ok to send it setImage:
//    UIImageView *imageView = (UIImageView *)self.view;
//    imageView.image = self.image;
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentOffset = CGPointMake(self.iv.bounds.size.width / 2 - scrollView.bounds.size.width / 2, self.iv.bounds.size.height / 2 - scrollView.bounds.size.height / 2);
}

// gold challenge ch19
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.iv;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *view = self.iv;
    CGPoint offset = scrollView.contentOffset;
    
    if (view.bounds.size.width * scrollView.zoomScale < scrollView.bounds.size.width) {
        offset.x = (view.bounds.size.width * scrollView.zoomScale - scrollView.bounds.size.width) / 2;
    }
    if (view.bounds.size.height *scrollView.zoomScale < scrollView.bounds.size.height) {
        offset.y = (view.bounds.size.height * scrollView.zoomScale - scrollView.bounds.size.height) / 2;
    }
    scrollView.contentOffset = offset;
}
// gold challenge ch19 end

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
