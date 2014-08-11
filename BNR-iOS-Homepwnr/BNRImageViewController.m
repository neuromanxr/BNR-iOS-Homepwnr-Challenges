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
    self.scrollView = [[UIScrollView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
//    imageView.contentMode = UIViewContentModeCenter;
//    self.view = imageView;
    
    self.iv = imageView;
    
    self.scrollView.contentSize = imageView.bounds.size;
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 10.0;
    [self.scrollView addSubview:self.iv];
    
    self.view = self.scrollView;
    
    // gold challenge ch19 end
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // we must cast the view to UIImageView so the compiler knows it
    // is ok to send it setImage:
//    UIImageView *imageView = (UIImageView *)self.view;
//    imageView.image = self.image;
    
    self.scrollView = (UIScrollView *)self.view;
    self.scrollView.contentOffset = CGPointMake(self.iv.bounds.size.width / 2 - self.scrollView.bounds.size.width / 2, self.iv.bounds.size.height / 2 - self.scrollView.bounds.size.height / 2);
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

// double tap to zoom
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.iv];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
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
