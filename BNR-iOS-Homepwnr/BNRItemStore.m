//
//  BNRItemStore.m
//  BNR-iOS-Homepwnr
//
//  Created by Kelvin Lee on 6/21/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore ()

// private mutable array only accessible by BNRItemStore
@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    // bronze challenge ch17
    // make it thread safe
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

// if you try to call [[BNRItemStore alloc] init]
// you get an error

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
}

// here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // instantiate private items mutable array
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

// method to change order of items in allItems array
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // get the pointer to object being moved so you can re-insert it
    BNRItem *item = self.privateItems[fromIndex];
    
    // remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}


@end
