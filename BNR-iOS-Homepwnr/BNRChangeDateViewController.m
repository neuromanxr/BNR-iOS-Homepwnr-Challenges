//
//  BNRChangeDateViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 7/12/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRChangeDateViewController.h"
#import "BNRItem.h"

@interface BNRChangeDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRChangeDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // gold challenge ch10
    self.datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)viewWillAppear:(BOOL)animated
{
    // gold challenge ch10
    // set the date picker date to match date created
    [super viewWillAppear:animated];
    BNRItem *item = self.item;
    
    self.datePicker.date = item.dateCreated;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // gold challenge ch10
    // access the items in BNRItem
    BNRItem *item = self.item;
    NSLog(@"item %@", item);
    
    // assign the new date from date picker to the item date created
    self.item.dateCreated = self.datePicker.date;
    
    NSLog(@"dateCreated %@", item.dateCreated);
    NSLog(@"%@", self.datePicker.date);
    // gold challenge ch10 end
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
