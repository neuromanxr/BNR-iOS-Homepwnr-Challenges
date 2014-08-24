//
//  BNRAssetTypeViewController.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 8/13/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRAssetTypeViewController.h"
#import "BNRDetailViewController.h"

@implementation BNRAssetTypeViewController

// ch23 silver challenge - add a new asset type
- (void)addNewAssetType
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"New Asset Type" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [av setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    
    NSString *at = [[alertView textFieldAtIndex:0] text];
    
    [[BNRItemStore sharedStore] createAssetType:at];
    
    [[self tableView] reloadData];
}
// ch23 silver challenge end

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem *assetTypes = [self navigationItem];
        [assetTypes setTitle:@"Asset Type"];
        
        UIBarButtonItem *newType = [[UIBarButtonItem alloc]
                                    initWithTitle:@"New"
                                    style: UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(addNewAssetType)];
        
        [[self navigationItem] setRightBarButtonItem:newType];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    
    // use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    // checkmark the one that is currently selected
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate didTap];
}

// uncheck cell that was deselected
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
