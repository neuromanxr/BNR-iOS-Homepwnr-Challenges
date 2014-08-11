//
//  BNRItemsViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 6/21/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRImageStore.h"
#import "BNRImageViewController.h"
#import "BNRDetailViewController.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRItemCell.h"

@interface BNRItemsViewController () <UITableViewDelegate, UIPopoverControllerDelegate>

// private property, strong because it will be a top level object in XIB
// use weak references for objects that are owned by top level objects
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIPopoverController *imagePopover;

@end

@implementation BNRItemsViewController

// getter method
// lazy instantiation, saves memory
// don't need this, have navigation controller
//- (UIView *)headerView
//{
//    // if you have not loaded the headerView yet
//    if (!_headerView) {
//        // load headerView.xib
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView"
//                                      owner:self
//                                    options:nil];
//    }
//    return _headerView;
//}

// BNRItemsViewController knows when a row is tapped because it is the table view's delegate
// when row is tapped in table view, its delegate is sent this method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    
    // so BNRDetailViewController has its item before viewWillAppear gets called
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = items[indexPath.row];
    
    // give detail view controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // push on top of navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    // create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    // completion block that will reload the table
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        // also remove row from table view with animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// bronze challenge
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

// don't need this, have navigation controller
//- (IBAction)toggleEditingMode:(id)sender
//{
//    // if you are currently in editing mode
//    if (self.isEditing) {
//        // change text of button to inform user of state
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        
//        // turn off editing mode
//        [self setEditing:NO animated:YES];
//    }
//    else
//    {
//        // change text of button to inform user of state
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        
//        // enter editing mode
//        [self setEditing:YES animated:YES];
//    }
//}

- (instancetype)init
{
    // call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    // don't need this, have insert new row
//    if (self) {
//        for (int i = 0; i < 5; i++) {
//            // make some items in the store
//            [[BNRItemStore sharedStore] createItem];
//        }
//    }
    
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
    
        // create a bar button item that will send addNewItem to BNRItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    
        // set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
        
        // register notification
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

// must implement these for view controller to conform to UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

// must implement to conform to data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get a new or recycled cell
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    // set the text on the cell with the description of item
    // that is at the nth index of items, where n = row this cell will appear in on the table view
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];

    // configure the cell with the BNRItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    // bronze challenge ch19
    if (item.valueInDollars > 50) {
        cell.valueLabel.textColor = [UIColor greenColor];
    } else {
        cell.valueLabel.textColor = [UIColor redColor];
    }
    // bronze challenge end
    
    // break the strong reference cycle
    __weak BNRItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        //
        BNRItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.itemKey;
            
            // if there is no image, we don't need to display anything
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            
            // make a rectangle for the frame of the thumbnail relative to
            // our table view
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            // create a new BNRImageViewController and set its image
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            // present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}

// update the sharedStore when reordering rows
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

// silver and gold challenge
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect footerRect = CGRectMake(0, 0, frame.size.width, 40);
    UILabel *tableFooter = [[UILabel alloc] initWithFrame:footerRect];
    tableFooter.text = @"No more items";
    tableFooter.backgroundColor = [UIColor redColor];
    tableFooter.textAlignment = NSTextAlignmentCenter;
    
    return tableFooter;
}

// override to register UITableViewCell class with table view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
    self.tableView.delegate = self;
    
    // tell the table view about its header view
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

// reload the UITableView so the user can see the changes immediately
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{ UIContentSizeCategoryExtraSmall : @44,
                                  UIContentSizeCategorySmall : @44,
                                  UIContentSizeCategoryMedium : @44,
                                  UIContentSizeCategoryLarge : @44,
                                  UIContentSizeCategoryExtraLarge : @55,
                                  UIContentSizeCategoryExtraExtraLarge : @65,
                                  UIContentSizeCategoryExtraExtraExtraLarge : @75 };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

@end
