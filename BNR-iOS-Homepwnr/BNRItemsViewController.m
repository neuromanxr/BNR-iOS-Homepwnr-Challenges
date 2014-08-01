//
//  BNRItemsViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 6/21/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemsViewController () <UITableViewDelegate>

// private property, strong because it will be a top level object in XIB
// use weak references for objects that are owned by top level objects
@property (nonatomic, strong) IBOutlet UIView *headerView;

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
    }
    return self;
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
    // create instance of UITableViewCell with default appearance
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // set the text on the cell with the description of item
    // that is at the nth index of items, where n = row this cell will appear in on the table view
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
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
    
    // reuse cells to use less memory
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.delegate = self;
    
    // tell the table view about its header view
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

// reload the UITableView so the user can see the changes immediately
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

@end
